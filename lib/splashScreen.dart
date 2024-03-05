import 'package:epawelaflutter/main.dart';
import 'package:epawelaflutter/welcomeScreen.dart' as WelcomeScreen;
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
    // Retrieve the Remember Me preference
    bool rememberMe = await _getRememberMeFromLocalStorage();

    // Navigate to the appropriate screen based on Remember Me preference
    if (rememberMe) {
      // If the user wants to be remembered, navigate to the main navigator
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => mainNavigator()));
    } else {
      // If the user doesn't want to be remembered, navigate to the welcome screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WelcomeScreen.WelcomeScreen()));
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
