import 'package:flutter/material.dart'; // Import Flutter material library for UI components
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase authentication library
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome icons library
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In library
import 'NavigationBar.dart'; // Import NavigationBar widget
import 'registrartionScreen.dart'; // Import RegistrationScreen widget
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences for local storage

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key); // Define LoginScreen widget

  @override
  _LoginScreenState createState() => _LoginScreenState(); // Create state for LoginScreen widget
}

class _LoginScreenState extends State<LoginScreen> { // Define state class for LoginScreen
  final TextEditingController _emailController = TextEditingController(); // Controller for email text field
  final TextEditingController _passwordController = TextEditingController(); // Controller for password text field

  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase authentication instance
  final GoogleSignIn googleSignIn = GoogleSignIn( // Google Sign-In instance
    clientId: '14844084599-c0ejcpte2m4q5jn66beppai7muua1gm2.apps.googleusercontent.com', // Client ID for Google Sign-In
  );

  bool _loading = false; // Flag for showing loading indicator
  bool _rememberMe = false; // Flag for remembering user login

  @override
  void initState() { // Initialize state
    super.initState();
    _getRememberMeFromLocalStorage(); // Retrieve Remember Me preference on initialization
  }

  Future<void> _signInWithGoogle(BuildContext context) async { // Function for Google Sign-In
    try {
      setState(() {
        _loading = true; // Set loading flag to true
      });

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn(); // Sign in with Google
      if (googleSignInAccount != null) { // If Google sign-in is successful
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential); // Sign in with Firebase credential

        print('User signed in with Google: ${userCredential.user?.displayName}'); // Print user info for debugging

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => mainNavigator())); // Navigate to the main screen after successful sign in
      }
    } catch (e) {
      print('Error signing in with Google: $e'); // Handle authentication errors
      ScaffoldMessenger.of(context).showSnackBar( // Display error message to the user
        SnackBar(
          content: Text('Failed to sign in with Google: $e'),
        ),
      );
    } finally {
      setState(() {
        _loading = false; // Set loading flag to false
      });
    }
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async { // Function for email and password sign-in
    try {
      setState(() {
        _loading = true; // Set loading flag to true
      });

      UserCredential userCredential = await _auth.signInWithEmailAndPassword( // Sign in with email and password
        email: _emailController.text,
        password: _passwordController.text,
      );

      print('User signed in with email: ${userCredential.user?.email}'); // Print user info for debugging

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => mainNavigator())); // Navigate to the main screen after successful sign in
    } catch (e) {
      print('Error signing in: $e'); // Handle authentication errors
      ScaffoldMessenger.of(context).showSnackBar( // Display error message to the user
        SnackBar(
          content: Text('Failed to sign in: $e'),
        ),
      );
    } finally {
      setState(() {
        _loading = false; // Set loading flag to false
      });
    }
  }

  void _getRememberMeFromLocalStorage() async { // Function to retrieve Remember Me preference from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('remember_me') ?? false; // Retrieve Remember Me preference from local storage
    });
  }

  void _saveRememberMeToLocalStorage(bool value) async { // Function to save Remember Me preference to local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', value); // Save Remember Me preference to local storage
  }

  @override
  Widget build(BuildContext context) { // Build the UI for LoginScreen
    return Scaffold( // Scaffold widget for layout structure
      backgroundColor: const Color.fromARGB(255, 68, 65, 65), // Set background color
      body: _loading // Show loading indicator if loading is true
          ? Center(
              child: CircularProgressIndicator(), // Show circular progress indicator in center
            )
          : SingleChildScrollView( // SingleChildScrollView to make the content scrollable
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      'Hello',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Sign in!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 50),
                    
                    const SizedBox(height: 20),
                    TextField( // Email text field
                      controller: _emailController, // Controller to control the text field
                      decoration: InputDecoration( // Input decoration for styling the text field
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.email, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField( // Password text field
                      controller: _passwordController, // Controller to control the text field
                      obscureText: true, // Hide the entered text
                      decoration: InputDecoration( // Input decoration for styling the text field
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.lock, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox( // Checkbox for Remember Me
                          value: _rememberMe, // Value of the checkbox
                          onChanged: (value) { // Function called when the checkbox value changes
                            setState(() {
                              _rememberMe = value!; // Update Remember Me value
                            });
                            _saveRememberMeToLocalStorage(_rememberMe); // Save Remember Me preference
                          },
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),                    
                    const SizedBox(height: 20),
                    ElevatedButton( // Sign-In button
                      onPressed: () {
                        _signInWithEmailAndPassword(context); // Function to sign in with email and password
                      },
                      style: ElevatedButton.styleFrom( // Styling for the button
                        primary: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextButton( // Button for navigating to registration screen
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegScreen(), // Navigate to RegistrationScreen
                              ),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
