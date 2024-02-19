import 'package:flutflix/auth.dart';
import 'package:flutflix/loginRegister.dart';
//import 'package:flutflix/firebase.dart';
import 'package:flutflix/loginScreen.dart';
import 'package:flutter/material.dart';

class widgetTree extends StatefulWidget {
  const widgetTree({super.key});

  @override
  State<widgetTree> createState() => _widgetTreeState();
}

class _widgetTreeState extends State<widgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          return loginPage();

        }else{
          return  registrationPage();
        }
      },
    );
  }
}