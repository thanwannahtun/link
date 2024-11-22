import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/data/hive/hive_util.dart';

import '../../core/utils/hive_box_name.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  final _hiveUtil = HiveUtil();

  _saveToHive(ThemeMode themeMode) async {
    await _hiveUtil.addValue<String>(
        HiveBoxName.themeMode, themeMode.name, HiveKeys.themeKey);
  }

  void toggleTheme() async {
    if (kDebugMode) {
      print(
          "toggleTheme : previous Theme : (${state.toString()} : ${state.name})");
    }
    if (state == ThemeMode.light) {
      await _saveToHive(ThemeMode.dark);
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
      await _saveToHive(ThemeMode.light);
    }
  }

  void setSystemTheme() async {
    await _saveToHive(ThemeMode.system);
    emit(ThemeMode.system);
  }

  getTheme() async {
    ThemeMode themeMode = await _getThemeMode();
    if (kDebugMode) {
      print("getTheme : (${themeMode.toString()} : ${themeMode.name})");
    }
    emit(themeMode);
  }

  /// Retrieve ThemeMode from a String
  Future<ThemeMode> _getThemeMode() async {
    final themeModeString = await _hiveUtil.getValueByKey<String>(
        HiveKeys.themeKey,
        boxName: HiveBoxName.themeMode,
        defaultValue: ThemeMode.system.name);
    return ThemeMode.values.firstWhere(
      (e) => e.name == themeModeString,
      orElse: () => ThemeMode.system, // Default fallback
    );
  }
}
/*
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
