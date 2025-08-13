import 'package:flutter_bay/data/models/product.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class ApiService {
  final ApiClient apiClient;

  ApiService({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();

  Future<List<Product>> getProducts({int? limit, int? offset}) async {
    String endpoint = '/products';

    final queryParams = <String, String>{};
    if (limit != null) queryParams['limit'] = limit.toString();
    if (offset != null) queryParams['offset'] = offset.toString();

    if (queryParams.isNotEmpty) {
      final query = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      endpoint += '?$query';
    }

    final jsonList = await apiClient.getList(endpoint);
    return jsonList
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
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
