import 'package:flutter/material.dart';
import 'package:helpdesk/main.dart';
import 'package:helpdesk/model/Pessoa.dart';

class HomeTecnico extends StatefulWidget {
  Pessoa _pessoa;
  HomeTecnico(this._pessoa);
  @override
  _HomeTecnicoState createState() => _HomeTecnicoState();
}

class _HomeTecnicoState extends State<HomeTecnico> {

  abrirPerfil(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Técnico"),
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
            leading: Icon(Icons.search,color: themeData.primaryColor,),
            title: Text(
              "Pesquisar ordens",
              style: TextStyle(color: themeData.primaryColor),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.person,color: themeData.primaryColor),
            title: Text(
              "Perfil",
              style: TextStyle(color: themeData.primaryColor),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.logout,color: themeData.primaryColor),
            title: Text(
              "Sair",
              style: TextStyle(color: themeData.primaryColor),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/login");
            }
          )
        ],
      )),
      body: Center(child: Text(widget._pessoa.nome)),
    );
  }
}