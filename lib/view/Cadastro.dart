import 'package:flutter/material.dart';
import 'package:helpdesk/main.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        color: themeData.primaryColor,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}