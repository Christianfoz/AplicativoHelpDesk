import 'package:flutter/material.dart';
import 'package:helpdesk/model/Pessoa.dart';

class HomeCliente extends StatefulWidget {
  Pessoa _pessoa;
  HomeCliente(this._pessoa);
  @override
  _HomeClienteState createState() => _HomeClienteState();
  
}

class _HomeClienteState extends State<HomeCliente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Cliente " + widget._pessoa.nome
          )
      ),
    );
  }
}