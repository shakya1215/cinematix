import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutflix/auth.dart';
import 'package:flutter/material.dart';

class loginPage extends StatelessWidget {
   loginPage({super.key});

  final User? user = Auth().currentUser;

  Future <void>  signOut() async{
    await Auth().signOut();
  }

  Widget _titile(){
    return const Text('Firebase Auth');
  }

  Widget _userUid(){
    return Text(user?.email ?? "user email");
  }

  Widget _signOutButton(){
    return ElevatedButton(
      onPressed: signOut, 
      child: const Text('Sign out'),
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
            _userUid(),
            _signOutButton()
          ],
        ),

      ),
    );
  }
}