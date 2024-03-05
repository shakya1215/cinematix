import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'NavigationBar.dart';
import 'login_Screen.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  String? errorMessage;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signUpWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      // Clear the error message and text controllers after successful registration
      setState(() {
        errorMessage = null;
        _controllerEmail.clear();
        _controllerPassword.clear();
      });
      // Registration successful, navigate to the main screen or perform other actions
      // For example, you can navigate to the main screen:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => mainNavigator()));
    } on FirebaseAuthException catch (e) {
      // Handle registration errors
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(40, 2, 10, 1),
                    Color.fromARGB(255, 2, 0, 4),
                  ],
                ),
              ),
              child: Text(
                'Create Your\nAccount',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 160.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Color.fromARGB(255, 68, 65, 65), // Changed to black
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _controllerEmail,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.check, color: Color.fromARGB(255, 234, 223, 223)),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Changed to white
                      ),
                    ),
                  ),
                  TextField(
                    controller: _controllerPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.visibility_off, color: Color.fromARGB(255, 245, 232, 232)),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Changed to white
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 70),
                  ElevatedButton(
                    onPressed: () => signUpWithEmailAndPassword(context),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 24, 24, 24),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color.fromARGB(255, 7, 7, 7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (errorMessage != null) Text(errorMessage!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
