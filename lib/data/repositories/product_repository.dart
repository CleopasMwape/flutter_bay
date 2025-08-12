// data/repositories/product_repository.dart

class ProductRepository {
  final ApiService apiService;
  final CacheService cacheService;

  ProductRepository({
    required this.apiService,
    required this.cacheService,
  });

  Future<List<Product>> getProducts({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final cachedProducts = await cacheService.getCachedProducts();
        if (cachedProducts.isNotEmpty) {
          return cachedProducts;
        }
      }

      final products = await apiService.getProducts();
      await cacheService.cacheProducts(products);
      return products;
    } catch (e) {
      // Try to return cached data if API fails
      final cachedProducts = await cacheService.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }
      rethrow;
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final cachedProduct = await cacheService.getCachedProduct(id);
      if (cachedProduct != null) {
        return cachedProduct;
      }

      final product = await apiService.getProduct(id);
      await cacheService.cacheProduct(product);
      return product;
    } catch (e) {
      final cachedProduct = await cacheService.getCachedProduct(id);
      if (cachedProduct != null) {
        return cachedProduct;
      }
      rethrow;
    }
  }

  Future<List<String>> getCategories() async {
    return await apiService.getCategories();
  }
}
