import 'package:flutter_bay/core/constants/app_constants.dart';
import 'package:flutter_bay/core/errors/exceptions.dart';
import 'package:flutter_bay/data/models/product.dart';
import 'package:hive/hive.dart';

class CacheService {
  Box<Map>? _productBox;
  Box<List>? _categoryBox;
  Box<String>? _metaBox;

  Future<void> init() async {
    try {
      _productBox = await Hive.openBox<Map>(AppConstants.cacheBoxName);
      _categoryBox = await Hive.openBox<List>('categories_cache');
      _metaBox = await Hive.openBox<String>('meta_cache');
    } catch (e) {
      throw CacheException('Failed to initialize cache: $e');
    }
  }

  Future<void> cacheProducts(List<Product> products) async {
    try {
      await _ensureInitialized();

      // Cache individual products
      for (final product in products) {
        await _productBox!.put(product.id, product.toJson());
      }

      // Cache product list
      final productIds = products.map((p) => p.id).toList();
      await _metaBox!.put('all_products', productIds.join(','));
      await _metaBox!.put('cache_timestamp', DateTime.now().toIso8601String());
    } catch (e) {
      throw CacheException('Failed to cache products: $e');
    }
  }

  Future<List<Product>> getCachedProducts() async {
    try {
      await _ensureInitialized();

      // Check if cache is expired
      if (await _isCacheExpired()) {
        return [];
      }

      final productIdsString = _metaBox!.get('all_products');
      if (productIdsString == null) return [];

      final productIds = productIdsString
          .split(',')
          .where((id) => id.isNotEmpty)
          .map((id) => int.tryParse(id))
          .where((id) => id != null)
          .cast<int>()
          .toList();

      final products = <Product>[];
      for (final id in productIds) {
        final productData = _productBox!.get(id);
        if (productData != null) {
          try {
            products.add(
              Product.fromJson(Map<String, dynamic>.from(productData)),
            );
          } catch (e) {
            // Skip invalid cached products
            continue;
          }
        }
      }

      return products;
    } catch (e) {
      throw CacheException('Failed to get cached products: $e');
    }
  }

  Future<Product?> getCachedProduct(int id) async {
    try {
      await _ensureInitialized();

      final productData = _productBox!.get(id);
      if (productData != null) {
        return Product.fromJson(Map<String, dynamic>.from(productData));
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached product: $e');
    }
  }

  Future<void> cacheProduct(Product product) async {
    try {
      await _ensureInitialized();
      await _productBox!.put(product.id, product.toJson());
    } catch (e) {
      throw CacheException('Failed to cache product: $e');
    }
  }

  Future<void> cacheCategories(List<String> categories) async {
    try {
      await _ensureInitialized();
      await _categoryBox!.put('categories', categories);
      await _metaBox!.put(
        'categories_timestamp',
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw CacheException('Failed to cache categories: $e');
    }
  }

  Future<List<String>> getCachedCategories() async {
    try {
      await _ensureInitialized();

      final categories = _categoryBox!.get('categories');
      if (categories != null) {
        return List<String>.from(categories);
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached categories: $e');
    }
  }

  Future<void> clearCache() async {
    try {
      await _ensureInitialized();
      await _productBox!.clear();
      await _categoryBox!.clear();
      await _metaBox!.clear();
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  Future<bool> _isCacheExpired() async {
    final timestampString = _metaBox!.get('cache_timestamp');
    if (timestampString == null) return true;

    try {
      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();
      return now.difference(timestamp) > AppConstants.cacheExpiration;
    } catch (e) {
      return true; // Consider expired if timestamp is invalid
    }
  }

  Future<void> _ensureInitialized() async {
    if (_productBox == null || _categoryBox == null || _metaBox == null) {
      await init();
    }
  }

  void dispose() {
    _productBox?.close();
    _categoryBox?.close();
    _metaBox?.close();
  }
}
