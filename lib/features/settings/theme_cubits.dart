import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/themes/dark_mode.dart';
import 'package:social_media_firebase/themes/light_mode.dart';

class ThemeCubits extends Cubit<ThemeData> {
  ThemeCubits() : super(darkMode);

  bool _isLightMode = false;
  bool get isLightMode => _isLightMode;
  void toggleTheme() {
    _isLightMode = !_isLightMode;
    if (_isLightMode) {
      emit(lightMode);
    } else {
      emit(darkMode);
    }
  }
}
