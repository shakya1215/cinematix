import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart'; // Import the Get package

import 'NavigationBar.dart';
import 'dependenncyInjection.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'kidsModeProvider.dart';
import 'welcomeScreen.dart' as WelcomeScreen;
import 'login_screen.dart' as LoginScreen;
// Assuming your main navigator file is named main_navigator.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => KidsModeProvider(),
      child: GetMaterialApp( // Use GetMaterialApp as the root widget
        debugShowCheckedModeBanner: false,
        title: 'cinematix',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color.fromARGB(255, 20, 20, 20),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    DependencyInjection.init();
    navigateToCorrectScreen();
  }

  Future<void> navigateToCorrectScreen() async {
    // Retrieve the Remember Me preference
    bool rememberMe = await _getRememberMeFromLocalStorage();

    // Navigate to the appropriate screen based on Remember Me preference
    if (rememberMe) {
      // If the user wants to be remembered, navigate to the main navigator
      Get.off(() => MainNavigator()); // Use Get.off to navigate without back button
    } else {
      // If the user doesn't want to be remembered, navigate to the welcome screen
      Get.off(() => WelcomeScreen.WelcomeScreen()); // Use Get.off to navigate without back button
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
