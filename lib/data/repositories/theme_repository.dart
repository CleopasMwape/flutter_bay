import 'package:flutter_bay/core/errors/result.dart';
import 'package:flutter_bay/data/services/shared_preferences_service.dart';

class ThemeRepository {
  ThemeRepository(this._service);

  final SharedPreferencesService _service;

  /// Get if dark mode is enabled
  Future<Result<bool>> isDarkMode() async {
    try {
      final value = await _service.isDarkMode();
      return Result.ok(value);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  /// Set dark mode
  Future<Result<void>> setDarkMode(bool value) async {
    try {
      await _service.setDarkMode(value);
      // _darkModeController.add(value);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
