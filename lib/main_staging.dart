import 'package:flutter_bay/app/app.dart';
import 'package:flutter_bay/bootstrap.dart';
import 'package:flutter_bay/data/repositories/product_repository.dart';
import 'package:flutter_bay/data/repositories/theme_repository.dart';
import 'package:flutter_bay/data/services/api_service.dart';
import 'package:flutter_bay/data/services/cache_service.dart';
import 'package:flutter_bay/data/services/shared_preferences_service.dart';

void main() {
  final apiService = ApiService();
  final cacheService = CacheService();
  final sharedPreferencesService = SharedPreferencesService();
  bootstrap(
    () => App(
      productRepository: ProductRepository(
        apiService: apiService,
        cacheService: cacheService,
      ),
      themeRepository: ThemeRepository(sharedPreferencesService),
    ),
  );
}
