import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const THEME_STATUS = "THEME_STATUS";
  bool _darktheme = false;
  bool get getIsDarkTheme => _darktheme;

  ThemeProvider() {
    getTheme();
  }
  setDarkTheme({required bool themeValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, themeValue);
    _darktheme = themeValue;
    notifyListeners();
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _darktheme = prefs.getBool(THEME_STATUS) ?? false;
    notifyListeners();
    return _darktheme;
  }
}
