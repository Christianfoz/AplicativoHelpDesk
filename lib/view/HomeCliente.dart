import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helpdesk/main.dart';
import 'package:helpdesk/model/Ordem.dart';
import 'package:helpdesk/model/Pessoa.dart';
import 'package:helpdesk/repository/OrdemRepository.dart';

class HomeCliente extends StatefulWidget {
  Pessoa _pessoa;
  HomeCliente(this._pessoa);
  @override
  _HomeClienteState createState() => _HomeClienteState();
}

class _HomeClienteState extends State<HomeCliente> {
  final OrdemRepository _ordemRepository = OrdemRepository();
  final _controller = StreamController<List<Ordem>>.broadcast();

  Future<Stream<List<Ordem>>> _adicionarListener() async {
    Stream<List<Ordem>> stream =
        Stream.fromFuture(_ordemRepository.listarOrdens());
    stream.listen((event) {
      _controller.add(event);
    });
  }

  _abrirTelaChamado() {
    Navigator.pushNamed(context, "/cadastrochamado", arguments: widget._pessoa);
  }

  abrirPerfil() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Cliente"),
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            GestureDetector(
              onTap: () => abrirPerfil(),
              child: UserAccountsDrawerHeader(
                accountEmail: Text(widget._pessoa.email),
                accountName:
                    Text(widget._pessoa.nome + " " + widget._pessoa.sobrenome),
                currentAccountPicture: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        "http://192.168.0.107:8080/${widget._pessoa.foto}")),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add, color: themeData.primaryColor),
              title: Text(
                "Cadastrar nova ordem",
                style: TextStyle(color: themeData.primaryColor),
              ),
              onTap: () => _abrirTelaChamado(),
            ),
            ListTile(
              leading: Icon(
                Icons.search,
                color: themeData.primaryColor,
              ),
              title: Text(
                "Pesquisar ordens",
                style: TextStyle(color: themeData.primaryColor),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.person, color: themeData.primaryColor),
              title: Text(
                "Perfil",
                style: TextStyle(color: themeData.primaryColor),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
                leading: Icon(Icons.logout, color: themeData.primaryColor),
                title: Text(
                  "Sair",
                  style: TextStyle(color: themeData.primaryColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/login");
                })
          ],
        )),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: themeData.primaryColor,
          onPressed: () => _abrirTelaChamado(),
        ),
        body: Container(
          color: themeData.primaryColor,
          child: Container(
            
          ),
        )
    );
    /*StreamBuilder(
        builder: (context, AsyncSnapshot<List<Ordem>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:  
              return CircularProgressIndicator();
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if(!snapshot.hasData){
                return Center(
                  child: Text(
                    "Nenhuma ordem encontrada"
                  ),
                );
              }
              else{
                return Expanded(
                        child: ListWheelScrollView(
                          children: [
                            //popular com dados
                          ],
                          itemExtent: 42,
                          useMagnifier: false,

                        ) 
                      );
              }
              break;
          }
        },
        stream: _controller.stream),*/
  }
}
