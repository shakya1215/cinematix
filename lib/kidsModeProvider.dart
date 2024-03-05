import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KidsModeProvider extends ChangeNotifier {
  bool _kidsMode = false;

  KidsModeProvider() {
    _loadKidsMode();
  }

  bool get kidsMode => _kidsMode;

  set kidsMode(bool newValue) {
    _kidsMode = newValue;
    _saveKidsMode(newValue);
    notifyListeners();
  }

  void _loadKidsMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _kidsMode = prefs.getBool('kidsMode') ?? false;
    notifyListeners();
  }

  void _saveKidsMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('kidsMode', value);
  }
}