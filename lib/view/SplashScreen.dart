import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helpdesk/main.dart';
import 'package:helpdesk/view/Login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(
      Duration(seconds: 2), (){
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => Login()));
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeData.primaryColor,
      body: Center(
        child: Text(
          "HelpDesk",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}