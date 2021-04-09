import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpdesk/main.dart';
import 'package:helpdesk/model/Ordem.dart';
import 'package:helpdesk/model/Pessoa.dart';
import 'package:helpdesk/repository/OrdemRepository.dart';
import 'package:helpdesk/util/CustomSearchDelegate.dart';
import 'package:helpdesk/util/PessoaFiltro.dart';
import 'package:helpdesk/util/PessoaOrdem.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomeCliente extends StatefulWidget {
  Pessoa _pessoa;
  HomeCliente(this._pessoa);
  @override
  _HomeClienteState createState() => _HomeClienteState();
}

class _HomeClienteState extends State<HomeCliente> {
  final OrdemRepository _ordemRepository = OrdemRepository();
  final _controller = StreamController<List<Ordem>>.broadcast();
  String _resultado = "";
  List<Ordem> _ordens;

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

  _detalharChamado(Ordem ordem) {
    PessoaOrdem _pessoaOrdem =
        PessoaOrdem(pessoa: widget._pessoa, ordem: ordem);
    Navigator.pushNamed(context, "/detalhechamado", arguments: _pessoaOrdem);
  }

  Color _verCor(Ordem ordem) {
    if (ordem.situacao.idSituacao == 1) {
      return Color(0xffff7b7b);
    } else if (ordem.situacao.idSituacao == 2) {
      return Color(0xffd5d1d6);
    } else {
      return Color(0xff0088cc);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListener();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  final result = await showSearch<String>(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  );
                }),
          ],
          title: Text(
            "Home Cliente",
            style: GoogleFonts.lato(),
          ),
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            GestureDetector(
              onTap: () => abrirPerfil(),
              child: UserAccountsDrawerHeader(
                accountEmail:
                    Text(widget._pessoa.email, style: GoogleFonts.lato()),
                accountName: Text(
                  widget._pessoa.nome + " " + widget._pessoa.sobrenome,
                  style: GoogleFonts.lato(),
                ),
                currentAccountPicture: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        "http://192.168.0.107:8080/${widget._pessoa.foto}")),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add, color: themeData.primaryColor),
              title: Text("Cadastrar nova ordem",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: themeData.primaryColor))),
              onTap: () => _abrirTelaChamado(),
            ),
            ListTile(
              leading: Icon(
                Icons.search,
                color: themeData.primaryColor,
              ),
              title: Text("Ordens Criadas",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: themeData.primaryColor))),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/ordemfiltro",
                    arguments: PessoaFiltro(filtro: 1, pessoa: widget._pessoa));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.search,
                color: themeData.primaryColor,
              ),
              title: Text("Ordens Em Andamento",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: themeData.primaryColor))),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/ordemfiltro",
                    arguments: PessoaFiltro(filtro: 2, pessoa: widget._pessoa));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.search,
                color: themeData.primaryColor,
              ),
              title: Text("Ordens Resolvidas",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: themeData.primaryColor))),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/ordemfiltro",
                    arguments: PessoaFiltro(filtro: 3, pessoa: widget._pessoa));
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: themeData.primaryColor),
              title: Text("Perfil",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: themeData.primaryColor))),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
                leading: Icon(Icons.logout, color: themeData.primaryColor),
                title: Text("Sair",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(color: themeData.primaryColor))),
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/ordemfiltro",
                        arguments:
                            PessoaFiltro(filtro: 1, pessoa: widget._pessoa)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Container(color: Color(0xffff7b7b)),
                      ),
                    ),
                  ),
                  Text("Criado", style: GoogleFonts.lato()),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/ordemfiltro",
                        arguments:
                            PessoaFiltro(filtro: 2, pessoa: widget._pessoa)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Container(color: Color(0xffd5d1d6)),
                      ),
                    ),
                  ),
                  Text("Em andamento", style: GoogleFonts.lato()),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/ordemfiltro",
                        arguments:
                            PessoaFiltro(filtro: 3, pessoa: widget._pessoa)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Container(color: Color(0xff0088cc)),
                      ),
                    ),
                  ),
                  Text("Resolvido", style: GoogleFonts.lato()),
                ],
              ),
            ),
            Expanded(
                child: StreamBuilder(
                    builder: (context, AsyncSnapshot<List<Ordem>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                          break;
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text("Nenhuma ordem encontrada"),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                Ordem ordem = snapshot.data[index];
                                return GestureDetector(
                                    onTap: () => _detalharChamado(ordem),
                                    child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Card(
                                          color: _verCor(ordem),
                                          child: Column(
                                            children: [
                                              Padding(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      "Ordem ${ordem.idOrdem}",
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                ),
                                                padding: EdgeInsets.all(10),
                                              ),
                                              Padding(
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        "Título: ${ordem.titulo}",
                                                        maxLines: 1,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ))),
                                                padding: EdgeInsets.all(10),
                                              ),
                                              Padding(
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Descrição: ${ordem.descricao}",
                                                      maxLines: 2,
                                                      style: GoogleFonts.lato(
                                                          textStyle: TextStyle(
                                                        fontSize: 16,
                                                      )),
                                                    )),
                                                padding: EdgeInsets.all(10),
                                              ),
                                              Padding(
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    //final formattedStr =
                                                    child: Text(
                                                      "Criado em " +
                                                          DateFormat(
                                                                  DateFormat
                                                                      .YEAR_MONTH_DAY,
                                                                  'pt_Br')
                                                              .format(ordem
                                                                  .dataInicio) +
                                                          " as " +
                                                          DateFormat('HH:mm',
                                                                  'pt_Br')
                                                              .format(ordem
                                                                  .dataInicio),
                                                      maxLines: 1,
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          fontSize: 13,
                                                          fontStyle: FontStyle.italic
                                                          ),
                                                      )
                                                    )),
                                                padding: EdgeInsets.all(10),
                                              )
                                            ],
                                          ),
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        )));
                              },
                            );
                          }
                          break;
                      }
                    },
                    stream: _controller.stream))
          ],
        ));
  }
}
