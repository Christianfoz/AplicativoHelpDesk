/* 

--------------------------------------------

Classe util para pesquisa de chamado por palavra


---------------------------------------------

*/



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpdesk/model/Ordem.dart';
import 'package:helpdesk/model/Pessoa.dart';
import 'package:helpdesk/repository/OrdemRepository.dart';
import 'package:helpdesk/util/PessoaFiltro.dart';
import 'package:helpdesk/util/PessoaOrdem.dart';
import 'package:intl/intl.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  Pessoa _pessoa;
  final _controller = StreamController<List<Ordem>>.broadcast();
  final OrdemRepository _ordemRepository = OrdemRepository();
  CustomSearchDelegate(this._pessoa);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = "")];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () => close(context, ""));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query == ""){
      Stream<List<Ordem>> stream =
        Stream.fromFuture(_ordemRepository.listarOrdens());
    stream.listen((event) {
      _controller.add(event);
    });
    }
    else{
      Stream<List<Ordem>> stream =
        Stream.fromFuture(_ordemRepository.listarOrdensPorTitulo(query));
    stream.listen((event) {
      _controller.add(event);
    });
    }
    _detalharChamado(Ordem ordem) {
      PessoaOrdem _pessoaOrdem =
          PessoaOrdem(pessoa: _pessoa, ordem: ordem);
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, "/ordemfiltro",
                    arguments: PessoaFiltro(filtro: 1, pessoa: _pessoa)),
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
                    arguments: PessoaFiltro(filtro: 2, pessoa: _pessoa)),
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
                    arguments: PessoaFiltro(filtro: 3, pessoa: _pessoa)),
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
                stream: _controller.stream))
      ],
    );
  }
}
