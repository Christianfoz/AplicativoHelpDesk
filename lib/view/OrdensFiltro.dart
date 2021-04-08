import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helpdesk/model/Ordem.dart';
import 'package:helpdesk/repository/OrdemRepository.dart';
import 'package:helpdesk/util/PessoaFiltro.dart';
import 'package:helpdesk/util/PessoaOrdem.dart';
import 'package:intl/intl.dart';

class OrdensFiltro extends StatefulWidget {
  PessoaFiltro _pessoaFiltro;
  OrdensFiltro(this._pessoaFiltro);
  @override
  _OrdensFiltroState createState() => _OrdensFiltroState();
}

class _OrdensFiltroState extends State<OrdensFiltro> {
  final OrdemRepository _ordemRepository = OrdemRepository();
  final _controller = StreamController<List<Ordem>>.broadcast();

   Future<Stream<List<Ordem>>> _adicionarListener() async {
    Stream<List<Ordem>> stream =
        Stream.fromFuture(_ordemRepository.listarOrdensPorSituacao(widget._pessoaFiltro.filtro));
    stream.listen((event) {
      _controller.add(event);
      print(event);
    });
  }

  Text _tituloAppBar(){
    if(widget._pessoaFiltro.filtro == 1){
      return Text("Ordens Criadas");
    }
    else if(widget._pessoaFiltro.filtro == 2){
      return Text("Ordens em Andamento");
    }
    else{
      return Text("Ordens resolvidas");
    }
  }

   _detalharChamado(Ordem ordem) {
    PessoaOrdem _pessoaOrdem =
        PessoaOrdem(pessoa: widget._pessoaFiltro.pessoa, ordem: ordem);
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
    return Scaffold(
      appBar: AppBar(
        title: _tituloAppBar(),
      ),
      body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Container(color: Color(0xffff7b7b)),
                    ),
                  ),
                  Text("Criado"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Container(color: Color(0xffd5d1d6)),
                    ),
                  ),
                  Text("Em andamento"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Container(color: Color(0xff0088cc)),
                    ),
                  ),
                  Text("Resolvido"),
                ],
              ),
            ),
            Expanded(
                child: StreamBuilder(
                    builder: (context, AsyncSnapshot<List<Ordem>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return CircularProgressIndicator();
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
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
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
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                padding: EdgeInsets.all(10),
                                              ),
                                              Padding(
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Descrição: ${ordem.descricao}",
                                                      maxLines: 5,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
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
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
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
        ),
    );
  }
}