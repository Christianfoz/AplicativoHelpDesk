import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpdesk/main.dart';
import 'package:helpdesk/model/Comentario.dart';
import 'package:helpdesk/model/Ordem.dart';
import 'package:helpdesk/model/Situacao.dart';
import 'package:helpdesk/repository/ComentarioRepository.dart';
import 'package:helpdesk/repository/OrdemRepository.dart';
import 'package:helpdesk/repository/PessoaRepository.dart';
import 'package:helpdesk/util/Ip.dart';
import 'package:helpdesk/util/PerfilUtil.dart';
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
  final _comentarioRepository = ComentarioRepository();
  final _formKey = GlobalKey<FormState>();
  final _formKeyComentario = GlobalKey<FormState>();
  final _controllerComentario = StreamController<List<Comentario>>.broadcast();
  Comentario _comentario = Comentario();

  /*------------------------------------------------------------------------------------


  Método para tela de edição do chamado


  ------------------------------------------------------------------------------------

  */

  _abrirTelaEdicaoChamado() {
    Navigator.pushNamed(context, "/editarchamado",
        arguments: widget._pessoaOrdem);
  }

  /*------------------------------------------------------------------------------------


  Abre tela de perfil caso o usuário clique na foto do criador do perfil ou do tecnico


  ------------------------------------------------------------------------------------

  */

  _abrirPerfil(int id) {
    //1 para clique em cliente
    //2 para clique em tecnico
    switch (id) {
      case 1:
        PerfilUtil _perfilUtil = PerfilUtil(
            pessoaLogada: widget._pessoaOrdem.pessoa,
            pessoaPerfil: widget._pessoaOrdem.ordem.cliente);
        Navigator.pop(context);
        Navigator.pushNamed(context, "/perfil", arguments: _perfilUtil);
        break;
      case 2:
        PerfilUtil _perfilUtil = PerfilUtil(
            pessoaLogada: widget._pessoaOrdem.pessoa,
            pessoaPerfil: widget._pessoaOrdem.ordem.tecnico);
        Navigator.pop(context);
        Navigator.pushNamed(context, "/perfil", arguments: _perfilUtil);
        break;
      default:
    }
  }

  /*------------------------------------------------------------------------------------


  Dialog de erro


  ------------------------------------------------------------------------------------

  */

  _dialogErro() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                ),
                Center(
                  child: Text("Tente novamente realizar a operação desejada."),
                )
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (widget._pessoaOrdem.pessoa.tipoPessoa.idTipoPessoa == 1) {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/homecliente",
                      arguments: widget._pessoaOrdem.pessoa);
                } else {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/hometecnico",
                      arguments: widget._pessoaOrdem.pessoa);
                }
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                child: Center(
                  child: Text(
                    "Ok",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(0, 128, 255, 1),
                    Color.fromRGBO(51, 153, 255, 1)
                  ]),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /*------------------------------------------------------------------------------------


  Esta dialog só aparecerá caso o técnico tenha mais de 3 chamados em andamento


  ------------------------------------------------------------------------------------

  */

  _dialogExcedido() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Center(
              child: Text(
                "Erro ao aceitar chamado",
                style: GoogleFonts.lato(),
              ),
            ),
            content: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Você excedeu o limite de 3 chamados aceitos por técnico. Termine os outros chamados e tente novamente",
                        style: GoogleFonts.lato(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/hometecnico",
                      arguments: widget._pessoaOrdem.pessoa);
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                  child: Center(
                    child: Text(
                      "Ok",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(0, 128, 255, 1),
                      Color.fromRGBO(51, 153, 255, 1)
                    ]),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ]);
      },
    );
  }

  /*------------------------------------------------------------------------------------


  Esta dialog aparecerá caso o técnico queira finalizar o chamado porém ele não foi o que aceitou antes


  ------------------------------------------------------------------------------------

  */

  _dialogErroFinalizar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Center(
              child: Text(
                "Erro ao realizar ação",
                style: GoogleFonts.lato(),
              ),
            ),
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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                  child: Center(
                    child: Text(
                      "Ok",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(0, 128, 255, 1),
                      Color.fromRGBO(51, 153, 255, 1)
                    ]),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ]);
      },
    );
  }

  /*------------------------------------------------------------------------------------


  Dialog aparecerá quando alguma ação der certo. A dialog da ALEGRIA


  ------------------------------------------------------------------------------------

  */

  _dialogSucesso() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Center(
                child: Text("Operação realizada com sucesso",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  if (widget._pessoaOrdem.pessoa.tipoPessoa.idTipoPessoa == 1) {
                    Navigator.pushNamed(context, "/homecliente",
                        arguments: widget._pessoaOrdem.pessoa);
                  } else {
                    Navigator.pushNamed(context, "/hometecnico",
                        arguments: widget._pessoaOrdem.pessoa);
                  }
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Center(
                    child: Text(
                      "Ok",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
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
            ]);
      },
    );
  }

  /*------------------------------------------------------------------------------------


  Método para atualizar o chamado de criado para em andamento


  ------------------------------------------------------------------------------------

  */

  Widget _atualizarSituacaoEmProgresso(Ordem ordem) {
    _ordemRepository.atualizarEstadoParaEmProgresso(ordem).then((value) {
      if (value) {
        return _dialogSucesso();
      } else {
        return _dialogErro();
      }
    }).onError((error, stackTrace) {
      return _dialogErro();
    });
  }

  /*------------------------------------------------------------------------------------


  Método para abrir dialog para inserção do campo solução pelo tecnico


  ------------------------------------------------------------------------------------

*/

  _alertInserirSolucao() {
    if (widget._pessoaOrdem.ordem.tecnico.idPessoa !=
        widget._pessoaOrdem.pessoa.idPessoa) {
      return _dialogErroFinalizar();
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            padding: EdgeInsets.all(8),
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
                          child: Flexible(
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
                          )),
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
                                  "Enviar Solução",
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

  /*------------------------------------------------------------------------------------


  Método para atualizar o chamado de em andamento para resolvido. Chamado pelo método abrirTelaSolucao caso tudo esteja
  certo


  ------------------------------------------------------------------------------------

*/

  _finalizarChamado() {
    Ordem _ordem = widget._pessoaOrdem.ordem;
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

  /*------------------------------------------------------------------------------------


  Método para verificar quantos chamados em andamento o técnico possue. Chamado pelo atualizarsituacaoemprogresso

  ------------------------------------------------------------------------------------

*/

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

/*------------------------------------------------------------------------------------


  Método para verificar situação do chamado para que o texto do botão seja trocado ou que o botão nem apareça

  ------------------------------------------------------------------------------------

*/

  Widget _verificarSituacao() {
    if (widget._pessoaOrdem.ordem.situacao.nomeSituacao == "Criado") {
      return Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Center(
          child: GestureDetector(
            onTap: () => _verificaQuantidadeChamados(),
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Center(
                child: Text("Aceitar Chamado",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
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
                child: Text("Finalizar Chamado",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
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

/*------------------------------------------------------------------------------------


  Método para abrir dialog da exclusão

------------------------------------------------------------------------------------

*/

  _abrirDialogExclusao() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Center(
                child: Text(
              "Exclusão de chamado",
              style: GoogleFonts.lato(),
            )),
            content: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Deseja realmente excluir o chamado? Você não poderá reverter após esta ação.",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  _ordemRepository
                      .deletarChamado(widget._pessoaOrdem.ordem.idOrdem)
                      .then((value) {
                    if (value) {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/homecliente",
                          arguments: widget._pessoaOrdem.pessoa);
                    } else {
                      _dialogErro();
                    }
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                  child: Center(
                    child: Text(
                      "Sim",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(0, 128, 255, 1),
                      Color.fromRGBO(51, 153, 255, 1)
                    ]),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                  child: Center(
                    child: Text(
                      "Não",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: themeData.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: themeData.primaryColor)),
                ),
              ),
            ]);
      },
    );
  }

  Color _verCorComentario(Comentario comentario) {
    if (comentario.criadorComentario.tipoPessoa.idTipoPessoa == 1) {
      return Color(0xffffffff);
    } else {
      return Color(0xff0088cc);
    }
  }

  Future<Stream<List<Comentario>>> _adicionarListenerComentario() async {
    Stream<List<Comentario>> stream = Stream.fromFuture(_comentarioRepository
        .listarComentarioPorChamado(widget._pessoaOrdem.ordem.idOrdem));
    stream.listen((event) {
      _controllerComentario.add(event);
    });
  }

  _mostrarFormularioComentario() {
    if (widget._pessoaOrdem.ordem.situacao.idSituacao == 3) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Form(
                  key: _formKeyComentario,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.lato(),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff0088cc), width: 2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      prefixIcon: Icon(
                        Icons.text_snippet,
                        color: themeData.primaryColor,
                      ),
                      labelText: "Comentário",
                    ),
                    keyboardType: TextInputType.text,
                    validator: (comentario) {
                      return Validador()
                          .add(Validar.OBRIGATORIO,
                              msg: "Insira seu comentario")
                          .maxLength(120,
                              msg:
                                  "Comentario deve ter menos de 120 caracteres")
                          .valido(comentario);
                    },
                    onSaved: (comentario) =>
                        _comentario.comentario = comentario,
                  )),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    color: themeData.primaryColor,
                    icon: Icon(
                      Icons.send,
                      color: themeData.primaryColor,
                    ),
                    onPressed: () async {
                      if (_formKeyComentario.currentState.validate()) {
                        _formKeyComentario.currentState.save();
                        _enviarComentario();
                      }
                    }),
              ),
            )
          ],
        ),
      );
    }
  }

  _enviarComentario() async {
    _comentario.criadorComentario = widget._pessoaOrdem.pessoa;
    _comentario.dataComentario = DateTime.now();
    _comentario.ordem = widget._pessoaOrdem.ordem;
    await _comentarioRepository.criarComentario(_comentario).then((value) {
      if (value) {
        _dialogSucesso();
      } else {
        _dialogErro();
      }
    });
  }

  Widget _mostrarSecaoComentario(BuildContext context) {
    return Center(
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
            "Comentários",
            style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 16)),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(8),
            child: Divider(
              thickness: 2,
            ),
          ))
        ]),
        /* 
        
        Só aparecerá o formulario se for o tecnico que aceitou o chamado ou se for a pessoa que criou o chamado

        */

        StreamBuilder(
          stream: _controllerComentario.stream,
          builder: (context, AsyncSnapshot<List<Comentario>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                    child: Text(
                  "Nenhum comentario encontrado",
                  style: GoogleFonts.lato(),
                ));
                break;
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Comentario comentario = snapshot.data[index];
                    return GestureDetector(
                        onTap: () => null,
                        child: Container(
                            padding: EdgeInsets.all(8),
                            child: Card(
                              color: _verCorComentario(comentario),
                              child: Column(
                                children: [
                                  Padding(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("${comentario.comentario}",
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                            ),
                                          )),
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  Padding(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        //final formattedStr =
                                        child: Text(
                                            "Postado pelo ${(comentario.criadorComentario.tipoPessoa.nomeTipoPessoa)}" +
                                                " em " +
                                                DateFormat(
                                                        DateFormat
                                                            .YEAR_MONTH_DAY,
                                                        'pt_Br')
                                                    .format(comentario
                                                        .dataComentario) +
                                                " as " +
                                                DateFormat('HH:mm', 'pt_Br')
                                                    .format(comentario
                                                        .dataComentario),
                                            maxLines: 2,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  fontSize: 13,
                                                  fontStyle: FontStyle.italic),
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
                break;
            }
          },
        ),
        widget._pessoaOrdem.ordem.tecnico == widget._pessoaOrdem.pessoa ||
                widget._pessoaOrdem.ordem.cliente == widget._pessoaOrdem.pessoa
            ? _mostrarFormularioComentario()
            : Container(),
      ],
    ));
  }

  /*------------------------------------------------------------------------------------


  Método build para criar tela

  ------------------------------------------------------------------------------------

*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListenerComentario();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: Text(
          "Detalhes do chamado",
          style: GoogleFonts.lato(),
        )),
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
                            Text("Informação do Cliente",
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
                                padding:
                                    const EdgeInsets.only(right: 4, bottom: 8),
                                child: GestureDetector(
                                  onTap: () => _abrirPerfil(1),
                                  child: CircleAvatar(
                                      backgroundImage: NetworkImage(Ip.ip +
                                          widget
                                              ._pessoaOrdem.ordem.cliente.foto),
                                      radius: 40),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, bottom: 8),
                                child: Text(
                                    widget._pessoaOrdem.ordem.cliente.nome +
                                        " " +
                                        widget._pessoaOrdem.ordem.cliente
                                            .sobrenome,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    )),
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
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 16)),
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
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800)),
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
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                  ),
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
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                  ),
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
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal)),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Situação: ${widget._pessoaOrdem.ordem.situacao.nomeSituacao}",
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  fontSize: 16,
                                )),
                              ),
                            ),
                          ),

                          /*------------------------------------------------------------------------------------


                              Verifica se há solução. Se sim mostra, ao contrário ele não mostra

                            ------------------------------------------------------------------------------------

                            */
                          widget._pessoaOrdem.ordem.solucao == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                        "Solução: ${widget._pessoaOrdem.ordem.solucao}",
                                        textAlign: TextAlign.justify,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                            fontSize: 16,
                                          ),
                                        )),
                                  ),
                                ),

                          /*------------------------------------------------------------------------------------


                              Verifica se há data de término. Se sim mostra, ao contrário ele não mostra

                            ------------------------------------------------------------------------------------

                            */
                          widget._pessoaOrdem.ordem.dataTermino == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                          "Chamado terminado em " +
                                              DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br')
                                                  .format(widget._pessoaOrdem
                                                      .ordem.dataTermino) +
                                              " as " +
                                              DateFormat('HH:mm', 'pt_Br')
                                                  .format(widget._pessoaOrdem
                                                      .ordem.dataTermino),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal)))),
                                ),
                          /*------------------------------------------------------------------------------------


                              Verifica se há técnico no chamado. Se sim mostra, ao contrário ele não mostra

                            ------------------------------------------------------------------------------------

                            */
                          widget._pessoaOrdem.ordem.tecnico == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: GestureDetector(
                                        onTap: () => _abrirPerfil(2),
                                        child: Text(
                                            "Chamado atendido por " +
                                                widget._pessoaOrdem.ordem
                                                    .tecnico.nome +
                                                " " +
                                                widget._pessoaOrdem.ordem
                                                    .tecnico.sobrenome,
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal))),
                                      )),
                                ),

                          /*

                                COMENTARIOS


                              */
                          widget._pessoaOrdem.ordem.situacao.nomeSituacao ==
                                      "Em andamento" ||
                                  widget._pessoaOrdem.ordem.situacao
                                          .nomeSituacao ==
                                      "Resolvido"
                              ? _mostrarSecaoComentario(context)
                              : Container(),
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
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 16)),
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
                                        child: Text("Sem imagem",
                                            style: GoogleFonts.lato()),
                                      )
                                    : Container(
                                        padding: EdgeInsets.all(16),
                                        height: 200,
                                        width: 300,
                                        child: Image.network(
                                          Ip.ip +
                                              widget._pessoaOrdem.ordem.imagem,
                                          fit: BoxFit.fill,
                                        ),
                                      )),
                          ),
                          //verifica se o criador do chamado é o mesmo que está logado
                          // se sim, aparecerá na tela opções de editar/excluir

                          widget._pessoaOrdem.pessoa.idPessoa ==
                                      widget._pessoaOrdem.ordem.cliente
                                          .idPessoa &&
                                  widget._pessoaOrdem.ordem.situacao
                                          .nomeSituacao ==
                                      "Criado"
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
                                        "Edição e Exclusão",
                                        style: GoogleFonts.lato(
                                            textStyle: TextStyle(fontSize: 16)),
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
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _abrirTelaEdicaoChamado();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  16, 8, 16, 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.edit,
                                                      color: Colors.white),
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4),
                                                      child: Text("Editar",
                                                          style:
                                                              GoogleFonts.lato(
                                                            textStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromRGBO(
                                                          0, 128, 255, 1),
                                                      Color.fromRGBO(
                                                          51, 153, 255, 1)
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // abre dialog confirmando exclusão
                                              _abrirDialogExclusao();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  16, 8, 16, 8),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete,
                                                      color: Colors.white),
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4),
                                                      child: Text(
                                                        "Excluir",
                                                        style: GoogleFonts.lato(
                                                            textStyle:
                                                                TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromRGBO(
                                                          0, 128, 255, 1),
                                                      Color.fromRGBO(
                                                          51, 153, 255, 1)
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
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
                                        style: GoogleFonts.lato(
                                            textStyle: TextStyle(fontSize: 16)),
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

//jesus do ceu