import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bay/core/errors/result.dart';
import 'package:flutter_bay/data/repositories/theme_repository.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(this._themeRepository)
    : super(const ThemeState(isDarkMode: false)) {
    on<ToggleTheme>(_onToggleTheme);
    on<LoadTheme>(_onLoadTheme);

    // Load saved theme on initialization
    add(LoadTheme());
  }

  final ThemeRepository _themeRepository;

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final newThemeMode = !state.isDarkMode;
    try {
      final result = await _themeRepository.setDarkMode(newThemeMode);
      if (result is Ok<void>) {
        emit(ThemeState(isDarkMode: newThemeMode));
      }
    } on Exception catch (e) {
      // emit(const ThemeState(isDarkMode: false));
    }
  }

  Future<void> _onLoadTheme(
    LoadTheme event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final result = await _themeRepository.isDarkMode();
      if (result is Ok<bool>) {
        emit(ThemeState(isDarkMode: result.value));
      }
    } on Exception catch (e) {
      // emit(const ThemeState(isDarkMode: false));
    }
  }
}
