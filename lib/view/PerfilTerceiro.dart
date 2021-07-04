import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpdesk/main.dart';
import 'package:helpdesk/model/Ordem.dart';
import 'package:helpdesk/repository/OrdemRepository.dart';
import 'package:helpdesk/util/Ip.dart';
import 'package:helpdesk/util/PerfilUtil.dart';
import 'package:helpdesk/util/PessoaOrdem.dart';
import 'package:intl/intl.dart';

class PerfilTerceiro extends StatefulWidget {
  PerfilUtil _perfilUtil;
  PerfilTerceiro(this._perfilUtil);
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<PerfilTerceiro> {
  final OrdemRepository _ordemRepository = OrdemRepository();
  final _controllerAceito = StreamController<List<Ordem>>.broadcast();
  final _controllerCriado = StreamController<List<Ordem>>.broadcast();

  /*------------------------------------------------------------------------------------


    Método para adicionar listener de chamados criados pela pessoa do tipo cliente


  ------------------------------------------------------------------------------------
*/

  Future<Stream<List<Ordem>>> _adicionarListenerChamadosCriados() async {
    Stream<List<Ordem>> streamCriado = Stream.fromFuture(
        _ordemRepository.listarChamadosCriadosPorPessoa(
            widget._perfilUtil.pessoaPerfil.idPessoa));
    streamCriado.listen((event) {
      _controllerCriado.add(event);
    });
  }

  /*------------------------------------------------------------------------------------


    Método para adicionar listener de chamados aceitos pela pessoa do tipo técnico


  ------------------------------------------------------------------------------------
*/

  Future<Stream<List<Ordem>>> _adicionarListenerChamadosAceitos() async {
    Stream<List<Ordem>> streamAceito = Stream.fromFuture(
        _ordemRepository.listarChamadosAceitosPorPessoa(
            widget._perfilUtil.pessoaPerfil.idPessoa));
    streamAceito.listen((event) {
      _controllerAceito.add(event);
    });
  }

/*------------------------------------------------------------------------------------


      Método para abrir tela de detalhe do chamado 


    ------------------------------------------------------------------------------------
*/

  _detalharChamado(Ordem ordem) {
    PessoaOrdem _pessoaOrdem =
        PessoaOrdem(pessoa: widget._perfilUtil.pessoaLogada, ordem: ordem);
    Navigator.pushNamed(context, "/detalhechamado", arguments: _pessoaOrdem);
  }

  /*------------------------------------------------------------------------------------


      Método para determinar cor do fundo do chamado a partir da cor do mesmo 


    ------------------------------------------------------------------------------------
  */

  Color _verCor(Ordem ordem) {
    if (ordem.situacao.idSituacao == 1) {
      return Color(0xffff7b7b);
    } else if (ordem.situacao.idSituacao == 2) {
      return Color(0xffd5d1d6);
    } else {
      return Color(0xff0088cc);
    }
  }

  Widget _mostrarLista() {
    if (widget._perfilUtil.pessoaPerfil.tipoPessoa.idTipoPessoa == 1) {
      return Container(
        child: Column(
          children: [
            Row(children: <Widget>[
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(8),
                child: Divider(
                  thickness: 2,
                ),
              )),
              Text("Chamados criados",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 16),
                  )),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(8),
                child: Divider(
                  thickness: 2,
                ),
              ))
            ]),
            StreamBuilder(
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
                          shrinkWrap: true,
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
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  "Ordem ${ordem.idOrdem}",
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ),
                                            padding: EdgeInsets.all(10),
                                          ),
                                          Padding(
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    "Título: ${ordem.titulo}",
                                                    maxLines: 1,
                                                    style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))),
                                            padding: EdgeInsets.all(10),
                                          ),
                                          Padding(
                                            child: Align(
                                                alignment: Alignment.centerLeft,
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
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ))),
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
                stream: _controllerCriado.stream)
          ],
        ),
      );
    } else {
      return Container(
          child: Column(children: [
        Row(children: <Widget>[
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(8),
            child: Divider(
              thickness: 2,
            ),
          )),
          Text("Chamados aceitos",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 16),
              )),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(8),
            child: Divider(
              thickness: 2,
            ),
          ))
        ]),
        StreamBuilder(
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
                      shrinkWrap: true,
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
                                          alignment: Alignment.centerLeft,
                                          child: Text("Ordem ${ordem.idOrdem}",
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ),
                                        padding: EdgeInsets.all(10),
                                      ),
                                      Padding(
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                                Text("Título: ${ordem.titulo}",
                                                    maxLines: 1,
                                                    style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))),
                                        padding: EdgeInsets.all(10),
                                      ),
                                      Padding(
                                        child: Align(
                                            alignment: Alignment.centerLeft,
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
                                            alignment: Alignment.centerRight,
                                            //final formattedStr =
                                            child: Text(
                                                "Criado em " +
                                                    DateFormat(
                                                            DateFormat
                                                                .YEAR_MONTH_DAY,
                                                            'pt_Br')
                                                        .format(
                                                            ordem.dataInicio) +
                                                    " as " +
                                                    DateFormat('HH:mm', 'pt_Br')
                                                        .format(
                                                            ordem.dataInicio),
                                                maxLines: 1,
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      fontSize: 13,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ))),
                                        padding: EdgeInsets.all(10),
                                      )
                                    ],
                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                )));
                      },
                    );
                  }
                  break;
              }
            },
            stream: _controllerAceito.stream)
      ]));
    }
  }

  /*------------------------------------------------------------------------------------


      initstate para inicializar listeners 


    ------------------------------------------------------------------------------------
  */

  @override
  void initState() {
    _adicionarListenerChamadosCriados();
    _adicionarListenerChamadosAceitos();
    super.initState();
  }

  /*------------------------------------------------------------------------------------


      método build para construção da tela 


    ------------------------------------------------------------------------------------
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Perfil de " + widget._perfilUtil.pessoaPerfil.nome,
            style: GoogleFonts.lato(),
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: themeData.primaryColor,
            padding: EdgeInsets.all(16),
            child: Center(
                child: Expanded(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 15,
                                spreadRadius: 4)
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 12, top: 12),
                              child: Center(
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                    Ip.ip +
                                        widget._perfilUtil.pessoaPerfil.foto,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Center(
                                child: Text(
                                  widget._perfilUtil.pessoaPerfil.nome +
                                      " " +
                                      widget._perfilUtil.pessoaPerfil.sobrenome,
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Center(
                                child: Text(
                                  widget._perfilUtil.pessoaPerfil.tipoPessoa
                                      .nomeTipoPessoa,
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ),
                            Row(children: <Widget>[
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Divider(
                                  thickness: 2,
                                ),
                              )),
                              Text("Dados de Contato",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 16),
                                  )),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Divider(
                                  thickness: 2,
                                ),
                              ))
                            ]),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.email,
                                      color: themeData.primaryColor),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget._perfilUtil.pessoaPerfil.email,
                                    style: GoogleFonts.lato(),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.phone,
                                      color: themeData.primaryColor),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget._perfilUtil.pessoaPerfil.telefone,
                                    style: GoogleFonts.lato(),
                                  ),
                                ),
                              ],
                            ),
                            _mostrarLista()

                            //lista de chamados criados
                            //chamados atendidos
                            // verifica se é cliente, caso seja não aparecerá a parte de seção de chamados atendidos
                          ]),
                        ))))));
  }
}
