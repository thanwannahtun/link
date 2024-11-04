import 'package:flutter_bloc/flutter_bloc.dart';

// Define ThemeState
enum ThemeState { light, dark, system }

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.light);

  void toggleTheme() {
    if (state == ThemeState.light) {
      emit(ThemeState.dark);
    } else {
      emit(ThemeState.light);
    }
  }

  void setSystemTheme() {
    emit(ThemeState.system);
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeState { light, dark, system }

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeState _currentThemeState = ThemeState.system;

  ThemeCubit() : super(ThemeMode.system);

  void toggleTheme(ThemeState themeState) {
    _currentThemeState = themeState;
    _emitThemeMode();
  }

  void updateSystemBrightness(Brightness brightness) {
    if (_currentThemeState == ThemeState.system) {
      final themeMode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
      emit(themeMode);
    }
  }

  void _emitThemeMode() {
    if (_currentThemeState == ThemeState.system) {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      final themeMode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
      emit(themeMode);
    } else if (_currentThemeState == ThemeState.dark) {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
  }
}


class SystemThemeObserver extends WidgetsBindingObserver {
  final ThemeCubit themeCubit;

  SystemThemeObserver(this.themeCubit);

  @override
  void didChangePlatformBrightness() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    themeCubit.updateSystemBrightness(brightness);
  }
}


void main() {
  final themeCubit = ThemeCubit();
  final systemThemeObserver = SystemThemeObserver(themeCubit);

  WidgetsBinding.instance.addObserver(systemThemeObserver);

  runApp(BlocProvider<ThemeCubit>(
    create: (_) => themeCubit,
    child: const MyApp(),
  ));
}

 */
