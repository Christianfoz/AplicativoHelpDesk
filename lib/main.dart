import 'package:flutter/material.dart';
import 'package:helpdesk/util/Route.dart';
import 'package:helpdesk/view/SplashScreen.dart';

final ThemeData themeData = ThemeData(
    primaryColor: Colors.blue[750],
    accentColor: Colors.white,
  );

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
    onGenerateRoute: RouteGen.generateRoute,
    theme: themeData,
  ));
}

