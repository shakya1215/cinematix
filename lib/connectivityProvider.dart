import 'package:connectivity/connectivity.dart'; // Importing the connectivity package.
import 'package:flutter/material.dart'; // Importing the Flutter material package.

// A ChangeNotifier class responsible for providing information about the device's connectivity status.
class ConnectivityProvider extends ChangeNotifier {
  ConnectivityResult _connectivityResult = ConnectivityResult.none; // Default to 'none' connectivity status.

  // Constructor that initializes the connectivity status and listens for changes.
  ConnectivityProvider() {
    Connectivity().onConnectivityChanged.listen((result) {
      _connectivityResult = result; // Update the connectivity status when it changes.
      notifyListeners(); // Notify the listeners about the change in connectivity status.
    });
  }

  // Getter method to retrieve the current connectivity status.
  ConnectivityResult get connectivityResult => _connectivityResult;
}
