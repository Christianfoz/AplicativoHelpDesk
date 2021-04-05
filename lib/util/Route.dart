import 'package:flutter/material.dart';
import 'package:helpdesk/view/Cadastro.dart';
import 'package:helpdesk/view/CadastroChamado.dart';
import 'package:helpdesk/view/DetalheChamado.dart';
import 'package:helpdesk/view/HomeCliente.dart';
import 'package:helpdesk/view/HomeTecnico.dart';
import 'package:helpdesk/view/Login.dart';

class RouteGen {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case "/login":
        return MaterialPageRoute(builder: (context) => Login());
        break;
      case "/cadastro":
        return MaterialPageRoute(builder: (context) => Cadastro());
        break;
      case "/homecliente":
        return MaterialPageRoute(builder: (context) => HomeCliente(args));
        break;
      case "/hometecnico":
        return MaterialPageRoute(builder: (context) => HomeTecnico(args));
        break;
      case "/cadastrochamado":
        return MaterialPageRoute(builder: (context) => CadastroChamado(args));
        break;
      case "/detalhechamado":
        return MaterialPageRoute(builder: (context) => DetalheChamado(args));
        break;
    }
  }
}
