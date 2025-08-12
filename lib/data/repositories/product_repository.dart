import 'package:flutter_bay/data/models/product.dart';
import 'package:flutter_bay/data/services/api_service.dart';

import '../../core/errors/exceptions.dart';

class ProductRepository {
  final ApiService apiService;
  final CacheService cacheService;

  ProductRepository({
    required this.apiService,
    required this.cacheService,
  });

  Future<List<Product>> getProducts({
    bool forceRefresh = false,
    int? limit,
    int? offset,
  }) async {
    try {
      if (!forceRefresh) {
        final cachedProducts = await cacheService.getCachedProducts();
        if (cachedProducts.isNotEmpty) {
          return cachedProducts;
        }
      }

      final products = await apiService.getProducts(
        limit: limit,
        offset: offset,
      );

      if (products.isNotEmpty) {
        await cacheService.cacheProducts(products);
      }

      return products;
    } catch (e) {
      // Try to return cached data if API fails
      if (!forceRefresh) {
        try {
          final cachedProducts = await cacheService.getCachedProducts();
          if (cachedProducts.isNotEmpty) {
            return cachedProducts;
          }
        } catch (cacheError) {
          // Ignore cache errors and throw original error
        }
      }
      rethrow;
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      // Try cache first
      final cachedProduct = await cacheService.getCachedProduct(id);
      if (cachedProduct != null) {
        return cachedProduct;
      }

      // Fetch from API
      final product = await apiService.getProduct(id);
      await cacheService.cacheProduct(product);
      return product;
    } catch (e) {
      // Try cache as fallback
      final cachedProduct = await cacheService.getCachedProduct(id);
      if (cachedProduct != null) {
        return cachedProduct;
      }
      rethrow;
    }
  }

  Future<List<String>> getCategories() async {
    try {
      // Try cache first
      final cachedCategories = await cacheService.getCachedCategories();
      if (cachedCategories.isNotEmpty) {
        return cachedCategories;
      }

      // Fetch from API
      final categories = await apiService.getCategories();
      if (categories.isNotEmpty) {
        await cacheService.cacheCategories(categories);
      }
      return categories;
    } catch (e) {
      // Try cache as fallback
      final cachedCategories = await cacheService.getCachedCategories();
      if (cachedCategories.isNotEmpty) {
        return cachedCategories;
      }
      rethrow;
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      return await apiService.getProductsByCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearCache() async {
    await cacheService.clearCache();
  }

  void dispose() {
    apiService.dispose();
    cacheService.dispose();
  }
}
