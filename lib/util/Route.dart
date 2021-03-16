import 'package:flutter/material.dart';
import 'package:helpdesk/view/Cadastro.dart';
import 'package:helpdesk/view/Home.dart';
import 'package:helpdesk/view/Login.dart';

class RouteGen {
  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;
    switch (settings.name) {
      case "/login":
        return MaterialPageRoute(builder: (context) => Login());
        break;
      case "/cadastro":
        return MaterialPageRoute(builder: (context) => Cadastro());
        break;
      case "/home":
        return MaterialPageRoute(builder: (context) => Home());
        break;
    }
  }
}
