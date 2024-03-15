import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';


class ConnectivityProvider extends ChangeNotifier {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  ConnectivityProvider() {
    Connectivity().onConnectivityChanged.listen((result) {
      _connectivityResult = result;
      notifyListeners();
    });
  }

  ConnectivityResult get connectivityResult => _connectivityResult;
}
