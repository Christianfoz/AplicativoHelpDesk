import 'package:flutter/material.dart';
import 'package:helpdesk/main.dart';
import 'package:helpdesk/model/Pessoa.dart';

class HomeCliente extends StatefulWidget {
  Pessoa _pessoa;
  HomeCliente(this._pessoa);
  @override
  _HomeClienteState createState() => _HomeClienteState();
}

class _HomeClienteState extends State<HomeCliente> {
  _abrirTelaChamado() {
    Navigator.pushNamed(context, "/cadastrochamado", arguments: widget._pessoa);
  }

  abrirPerfil(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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
            leading: Icon(Icons.add,color: themeData.primaryColor),
            title: Text(
              "Cadastrar nova ordem",
              style: TextStyle(color: themeData.primaryColor),
            ),
            onTap: () => _abrirTelaChamado(),
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
          )
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
      body: Center(child: Text("Cliente " + widget._pessoa.nome)),
    );
  }
}
/*

bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (indice){
          setState(() {
            switch (indice) {
              case 0:
                
                break;
              case 1:

                break;
              case 2:
                break;
              default:
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Pesquisa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),

      */
