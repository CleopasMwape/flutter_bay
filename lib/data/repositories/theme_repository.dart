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
      _darkModeController.add(value);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
