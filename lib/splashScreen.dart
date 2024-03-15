
import 'package:cinematic/main.dart';
import 'package:connectivity/connectivity.dart';

import 'welcomeScreen.dart' as WelcomeScreen;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NavigationBar.dart';
import 'login_Screen.dart';
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToCorrectScreen();
  }

  Future<void> navigateToCorrectScreen() async {
    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // If there is no internet connection, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // If there is internet connection, proceed with navigation
      bool rememberMe = await _getRememberMeFromLocalStorage();
      if (rememberMe) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => mainNavigator()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WelcomeScreen.WelcomeScreen()));
      }
    }
  }

  Future<bool> _getRememberMeFromLocalStorage() async {
    // Retrieve the Remember Me preference from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('remember_me') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
