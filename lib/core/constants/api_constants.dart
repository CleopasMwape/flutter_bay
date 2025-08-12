// core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String productsEndpoint = '$baseUrl/products';
  static const String categoriesEndpoint = '$baseUrl/products/categories';

  // Pagination
  static const int pageSize = 20;

  // Timeout
  static const Duration timeout = Duration(seconds: 30);
}
