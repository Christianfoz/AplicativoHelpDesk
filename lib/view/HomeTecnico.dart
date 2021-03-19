import 'package:flutter/material.dart';
import 'package:helpdesk/model/Pessoa.dart';

class HomeTecnico extends StatefulWidget {
  Pessoa _pessoa;
  HomeTecnico(this._pessoa);
  @override
  _HomeTecnicoState createState() => _HomeTecnicoState();
  
}

class _HomeTecnicoState extends State<HomeTecnico> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Técnico " + widget._pessoa.nome
          )
      ),
    );
  }
}