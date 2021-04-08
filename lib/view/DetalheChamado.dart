import 'package:flutter/material.dart';
import 'package:helpdesk/main.dart';
import 'package:helpdesk/model/Ordem.dart';
import 'package:helpdesk/model/Situacao.dart';
import 'package:helpdesk/repository/OrdemRepository.dart';
import 'package:helpdesk/repository/PessoaRepository.dart';
import 'package:helpdesk/util/PessoaOrdem.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:validadores/validadores.dart';

class DetalheChamado extends StatefulWidget {
  PessoaOrdem _pessoaOrdem;
  DetalheChamado(this._pessoaOrdem);
  @override
  _DetalheChamadoState createState() => _DetalheChamadoState();
}

class _DetalheChamadoState extends State<DetalheChamado> {
  final _repository = PessoaRepository();
  final _ordemRepository = OrdemRepository();
  final _formKey = GlobalKey<FormState>();

  _dialogErro() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "Erro",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          actions: [
            Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/hometecnico",
                          arguments: widget._pessoaOrdem.pessoa);
                    },
                    child: Text("OK")))
          ],
        );
      },
    );
  }

  _dialogExcedido() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Erro ao aceitar chamado",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Você excedeu o limite de 3 chamados aceitos por técnico. Termine os outros chamados e tente novamente",
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/hometecnico",
                            arguments: widget._pessoaOrdem.pessoa);
                      },
                      child: Text("OK")))
            ]);
      },
    );
  }

  _dialogErroFinalizar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Você não é o técnico que aceitou o chamado",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK")))
            ]);
      },
    );
  }

  _dialogSucesso() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Operação realizada com sucesso",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/hometecnico",
                            arguments: widget._pessoaOrdem.pessoa);
                      },
                      child: Text("OK")))
            ]);
      },
    );
  }

  Widget _atualizarSituacaoEmProgresso(Ordem ordem) {
    _ordemRepository.atualizarEstadoParaEmProgresso(ordem).then((value) {
      if(value){
        return _dialogSucesso();
      }else{
        return _dialogErro();
      }
    }).onError((error, stackTrace) {
      return _dialogErro();
    });
  }

  _alertInserirSolucao() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "Insira a solução do chamado",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          maxLines: null,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xff0088cc), width: 2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            prefixIcon: Icon(Icons.text_snippet),
                            labelText: "Solucão",
                          ),
                          onSaved: (String solucao) =>
                              widget._pessoaOrdem.ordem.solucao = solucao,
                          validator: (descricao) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo Solução é obrigatório")
                                .valido(descricao);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Center(
                          child: GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                _finalizarChamado();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Center(
                                child: Text(
                                  "Enviar chamado",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(0, 128, 255, 1),
                                  Color.fromRGBO(51, 153, 255, 1)
                                ]),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _finalizarChamado() {
    Ordem _ordem = widget._pessoaOrdem.ordem;
    if (_ordem.tecnico.idPessoa != widget._pessoaOrdem.ordem.tecnico.idPessoa) {
      return _dialogErroFinalizar();
    } else {
      _ordem.situacao = Situacao.alt(3, "Resolvido");
      _ordemRepository.atualizarEstadoParaResolvido(_ordem).then((value) {
        if (value) {
          return _dialogSucesso();
        } else {
          return _dialogErro();
        }
      }).onError((error, stackTrace) {
        return _dialogErro();
      });
    }
  }

  _verificaQuantidadeChamados() {
    _repository
        .verificarQuantidadeChamado(widget._pessoaOrdem.pessoa.idPessoa)
        .then((value) {
      if (value == null) {
        return _dialogErro();
      } else if (value >= 3) {
        return _dialogExcedido();
      } else {
        Ordem _ordem = widget._pessoaOrdem.ordem;
        _ordem.situacao = Situacao.alt(2, "Em andamento");
        _ordem.tecnico = widget._pessoaOrdem.pessoa;
        _atualizarSituacaoEmProgresso(_ordem); 
    }
        });
  }
    

  Widget _verificarSituacao() {
    if (widget._pessoaOrdem.ordem.situacao.nomeSituacao == "Criada") {
      return Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Center(
          child: GestureDetector(
            onTap: () => _verificaQuantidadeChamados(),
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Center(
                child: Text(
                  "Aceitar Chamado",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(0, 128, 255, 1),
                  Color.fromRGBO(51, 153, 255, 1)
                ]),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      );
    } else if (widget._pessoaOrdem.ordem.situacao.nomeSituacao ==
        "Em andamento") {
      return Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Center(
          child: GestureDetector(
            onTap: () => _alertInserirSolucao(),
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Center(
                child: Text(
                  "Finalizar Chamado",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(0, 128, 255, 1),
                  Color.fromRGBO(51, 153, 255, 1)
                ]),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    return Scaffold(
        appBar: AppBar(title: Text("Detalhes do chamado")),
        body: Container(
          color: themeData.primaryColor,
          child: Center(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey, blurRadius: 15, spreadRadius: 4)
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(16),
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
                            Text(
                              "Informação do Cliente",
                              style: TextStyle(fontSize: 16),
                            ),
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
                                padding:
                                    const EdgeInsets.only(right: 4, bottom: 8),
                                child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "http://192.168.0.107:8080/${widget._pessoaOrdem.ordem.cliente.foto}"),
                                    radius: 40),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, bottom: 8),
                                child: Text(
                                  widget._pessoaOrdem.ordem.cliente.nome +
                                      " " +
                                      widget
                                          ._pessoaOrdem.ordem.cliente.sobrenome,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          Row(children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Divider(
                                thickness: 2,
                              ),
                            )),
                            Text(
                              "Informação do Chamado",
                              style: TextStyle(fontSize: 16),
                            ),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Divider(
                                thickness: 2,
                              ),
                            ))
                          ]),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                widget._pessoaOrdem.ordem.titulo,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                widget._pessoaOrdem.ordem.descricao,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Local: ${widget._pessoaOrdem.ordem.local.local}",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Criado em " +
                                      DateFormat(DateFormat.YEAR_MONTH_DAY,
                                              'pt_Br')
                                          .format(widget
                                              ._pessoaOrdem.ordem.dataInicio) +
                                      " as " +
                                      DateFormat('HH:mm', 'pt_Br').format(
                                          widget._pessoaOrdem.ordem.dataInicio),
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Situação: ${widget._pessoaOrdem.ordem.situacao.nomeSituacao}",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          widget._pessoaOrdem.ordem.solucao == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "Solução: ${widget._pessoaOrdem.ordem.solucao}",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                          widget._pessoaOrdem.ordem.dataTermino == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Chamado terminado em " +
                                            DateFormat(
                                                    DateFormat.YEAR_MONTH_DAY,
                                                    'pt_Br')
                                                .format(widget._pessoaOrdem
                                                    .ordem.dataTermino) +
                                            " as " +
                                            DateFormat('HH:mm', 'pt_Br').format(
                                                widget._pessoaOrdem.ordem
                                                    .dataTermino),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      )),
                                ),
                          Row(children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Divider(
                                thickness: 2,
                              ),
                            )),
                            Text(
                              "Imagem do Chamado",
                              style: TextStyle(fontSize: 16),
                            ),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Divider(
                                thickness: 2,
                              ),
                            ))
                          ]),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                                child: widget._pessoaOrdem.ordem.imagem ==
                                        "sem-imagem.png"
                                    ? Center(
                                        child: Text("Sem imagem"),
                                      )
                                    : Container(
                                        padding: EdgeInsets.all(16),
                                        height: 200,
                                        width: 300,
                                        child: Image.network(
                                          "http://192.168.0.107:8080/${widget._pessoaOrdem.ordem.imagem}",
                                          fit: BoxFit.fill,
                                        ),
                                      )),
                          ),
                          widget._pessoaOrdem.pessoa.tipoPessoa
                                      .nomeTipoPessoa ==
                                  "Técnico"
                              ? Column(
                                  children: [
                                    Row(children: <Widget>[
                                      Expanded(
                                          child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Divider(
                                          thickness: 2,
                                        ),
                                      )),
                                      Text(
                                        "Opções de Técnico",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Divider(
                                          thickness: 2,
                                        ),
                                      ))
                                    ]),
                                    _verificarSituacao()
                                  ],
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ))),
          padding: EdgeInsets.all(16),
        ));
  }
}
