import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class registrationPage extends StatefulWidget {
  const registrationPage({super.key});

  @override
  State<registrationPage> createState() => _registrationPageState();
}

class _registrationPageState extends State<registrationPage> {
  String ? errorMassage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future <void> signInWithEmailAndPassword() async{
    try{
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text, 
        password: _controllerPassword.text,
      );
    } on FirebaseException catch (e) {
      setState(() {
        errorMassage = e.message;
      });
    }

  }

  Future<void> createUserWithEmailAndPassword() async{
    try{
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
         password: _controllerPassword.text
      );
    } on FirebaseException catch (e) {
      setState(() {
        setState(() {
        errorMassage = e.message;
      });
      });
    }
  }

  Widget _titile(){
    return const Text('Firebase Auth');

  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ){
    
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  } 

  Widget _errorMessage(){
    return Text(errorMassage == ''? '': 'Humm ? $errorMassage' );
  }

  Widget _submitButton(){
    return ElevatedButton(
      onPressed: 
        isLogin? signInWithEmailAndPassword: createUserWithEmailAndPassword,
     child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton(){
    return TextButton(
      onPressed: (){
        setState(() {
          isLogin = !isLogin;
        });
      },
       child: Text(isLogin ? 'register instead': 'Login instead'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: _titile(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('email', _controllerEmail),
            _entryField('password', _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),

      ),
    );
  }
}