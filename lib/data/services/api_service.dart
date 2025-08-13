import 'package:flutter/foundation.dart';
import 'package:flutter_bay/data/models/product.dart';

import '../../core/network/api_client.dart';

class ApiService {
  ApiService({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();
  final ApiClient apiClient;

  Future<List<Product>> getProducts({int? limit, int? offset}) async {
    var endpoint = '/products';

    final queryParams = <String, String>{};
    if (limit != null) queryParams['limit'] = limit.toString();
    if (offset != null) queryParams['offset'] = offset.toString();

    if (queryParams.isNotEmpty) {
      final query = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      endpoint += '?$query';
    }

    try {
      final jsonList = await apiClient.getList(endpoint);
      if (kDebugMode) {
        print(jsonList);
      }

      final products = jsonList
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
      print('Fetched ${products.length}: $products');
      return products;
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<Product> getProduct(int id) async {
    final json = await apiClient.get('/products/$id');
    return Product.fromJson(json);
  }

  Future<List<String>> getCategories() async {
    final categories = await apiClient.getList('/products/categories');
    return categories.cast<String>();
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final jsonList = await apiClient.getList('/products/category/$category');
    return jsonList
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  void dispose() {
    apiClient.dispose();
  }
}
