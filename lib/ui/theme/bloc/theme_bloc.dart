import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    emit(ThemeState(isDarkMode: newThemeMode));

    await _themeRepository.setDarkMode(newThemeMode);
  }

  Future<void> _onLoadTheme(
    LoadTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final value = await _themeRepository.isDarkMode();
    emit(ThemeState(isDarkMode: value));
  }
}
