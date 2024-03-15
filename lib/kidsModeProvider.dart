import 'package:flutter/material.dart'; // Importing material.dart.
import 'package:shared_preferences/shared_preferences.dart'; // Importing SharedPreferences package.

// A provider class for managing kids mode.
class KidsModeProvider extends ChangeNotifier {
  bool _kidsMode = false; // Initialize kids mode to false.

  KidsModeProvider() {
    _loadKidsMode(); // Load kids mode status when the provider is initialized.
  }

  bool get kidsMode => _kidsMode; // Getter method to get the current kids mode status.

  set kidsMode(bool newValue) {
    _kidsMode = newValue; // Update the kids mode status.
    _saveKidsMode(newValue); // Save the updated kids mode status.
    notifyListeners(); // Notify listeners about the change.
  }

  // Function to load kids mode status from SharedPreferences.
  void _loadKidsMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _kidsMode = prefs.getBool('kidsMode') ?? false; // Get kids mode status from SharedPreferences.
    notifyListeners(); // Notify listeners about the change.
  }

  // Function to save kids mode status to SharedPreferences.
  void _saveKidsMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('kidsMode', value); // Save kids mode status to SharedPreferences.
  }
}
