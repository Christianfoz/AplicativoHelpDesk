import 'package:flutter/material.dart';
import 'package:helpdesk/model/Pessoa.dart';

class HomeCliente extends StatefulWidget {
  Pessoa _pessoa;
  HomeCliente(this._pessoa);
  @override
  _HomeClienteState createState() => _HomeClienteState();
  
}

class _HomeClienteState extends State<HomeCliente> {
  int _indiceAtual = 0;

  _abrirTelaChamado(){

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
            DrawerHeader(
              child: Row(
                children: [
                   Padding(
                     padding: EdgeInsets.all(1),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage("http://192.168.0.107:8080/${widget._pessoa.foto}")),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 27,bottom: 13),
                        child: Text(
                          widget._pessoa.nome + " " + widget._pessoa.sobrenome,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                ],
              )),
              

          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _abrirTelaChamado(),
      ),
      
      body: Center(
        child: Text(
          "Cliente " + widget._pessoa.nome
          )
      ),
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