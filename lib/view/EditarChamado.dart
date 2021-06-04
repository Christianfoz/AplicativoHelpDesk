import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpdesk/main.dart';
import 'package:helpdesk/model/Local.dart';
import 'package:helpdesk/model/Ordem.dart';
import 'package:helpdesk/model/Situacao.dart';
import 'package:helpdesk/repository/LocalRepository.dart';
import 'package:helpdesk/repository/OrdemRepository.dart';
import 'package:helpdesk/repository/PessoaRepository.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:validadores/validadores.dart';

import '../util/Ip.dart';
import '../util/PessoaOrdem.dart';

class EditarChamado extends StatefulWidget {
  PessoaOrdem _pessoaOrdem;
  EditarChamado(this._pessoaOrdem);
  @override
  _EditarChamadoState createState() => _EditarChamadoState();
}

class _EditarChamadoState extends State<EditarChamado> {
  File _imagemSelecionada;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  Ordem _ordemEditada = Ordem();
  Local _local = Local.alt();
  final PessoaRepository _repository = PessoaRepository();
  final OrdemRepository _ordemRepository = OrdemRepository();
  final LocalRepository _localRepository = LocalRepository();

  _mostrarDialogEsperando(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: new Row(
            children: [
              Container(
                child: CircularProgressIndicator(),
                padding: EdgeInsets.only(left: 5, right: 5),
              ),
              Container(child: Text("Enviando")),
            ],
          ),
        );
      },
    );
  }

  _tirarFotoCamera() async {
    final pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    File imagemSelecionada = File(pickedFile.path);
    if (imagemSelecionada != null) {
      setState(() {
        _imagemSelecionada = imagemSelecionada;
      });
    }
  }

  _tirarFotoGaleria() async {
    final pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    File imagemSelecionada = File(pickedFile.path);
    if (imagemSelecionada != null) {
      setState(() {
        _imagemSelecionada = imagemSelecionada;
      });
    }
  }

  _editarOrdem() async {
    _mostrarDialogEsperando(context);
    if (_imagemSelecionada == null) {
      
    } else {
      String url = await _repository.enviarFoto(_imagemSelecionada);
      _ordemEditada.imagem = url;
    }
    await _ordemRepository.editarOrdem(_ordemEditada);
    Navigator.pop(context);
    Navigator.pushNamed(context, "/homecliente",arguments: widget._pessoaOrdem.pessoa);
  }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ordemEditada = widget._pessoaOrdem.ordem;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Cadastro de Chamado",
            style: GoogleFonts.lato(),),
        ),
        body: Container(
            color: themeData.primaryColor,
            padding: EdgeInsets.all(16),
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
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 4, top: 8, right: 4),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: TextFormField(
                                      initialValue: widget._pessoaOrdem.ordem.titulo,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      labelStyle: GoogleFonts.lato(),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xff0088cc),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        prefixIcon: Icon(Icons.title),
                                        labelText: "Título",
                                      ),
                                    onSaved: (String titulo) =>
                                        _ordemEditada.titulo = titulo,
                                    validator: (titulo) {
                                      return Validador()
                                          .add(Validar.OBRIGATORIO,
                                              msg:
                                                  "Campo Título é obrigatório ")
                                          .valido(titulo);
                                    },
                                  ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: TextFormField(
                                      initialValue: widget._pessoaOrdem.ordem.descricao,
                                    maxLines: null,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      labelStyle: GoogleFonts.lato(),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xff0088cc),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        prefixIcon: Icon(Icons.text_snippet),
                                        labelText: "Descricao",
                                      ),
                                    onSaved: (String descricao) =>
                                        _ordemEditada.descricao = descricao,
                                    validator: (descricao) {
                                      return Validador()
                                          .add(Validar.OBRIGATORIO,
                                              msg:
                                                  "Campo Descrição é obrigatório")
                                          .valido(descricao);
                                    },
                                  ),
                                  ),
                                  Container(
                                    child: TypeAheadFormField<Local>(
                                      direction: AxisDirection.up,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                            controller: _typeAheadController,
                                            decoration: InputDecoration(
                                              labelStyle: GoogleFonts.lato(),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xff0088cc),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        prefixIcon: Icon(Icons.location_pin),
                                        labelText: "Local",
                                      )),
                                    transitionBuilder:
                                        (context, suggestionsBox, controller) {
                                      return suggestionsBox;
                                    },
                                    loadingBuilder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Text("Nenhum local encontrado")
                                        ),
                                      );
                                    },
                                    itemBuilder: (context, itemData) {
                                      return ListTile(
                                        title: Text(
                                          itemData.local,
                                          style: GoogleFonts.lato(),
                                        ),
                                      );
                                    },
                                    suggestionsCallback: (pattern) async {
                                      if (pattern == "") {
                                        return await _localRepository
                                            .listarLocais();
                                      } else {
                                        return await _localRepository
                                            .listarLocaisPorPalavra(pattern);
                                      }
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      setState(() {
                                        this._typeAheadController.text =
                                            suggestion.local;
                                        _local = suggestion;
                                      });
                                      _local = suggestion;
                                    },
                                    onSaved: (newValue) =>
                                        _local.local = newValue,
                                    validator: (value) {
                                      return Validador()
                                          .add(Validar.OBRIGATORIO,
                                              msg: "Campo local é obrigatório")
                                          .valido(value);
                                    },
                                  ),
                                    padding: EdgeInsets.all(8),
                                  ),
                                  
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    height: 200,
                                    width: 300,
                                    child: _imagemSelecionada == null
                                        ? Image.network(
                                            Ip.ip + "${widget._pessoaOrdem.ordem.imagem}",
                                            fit: BoxFit.fill,
                                          )
                                        : Image.file(
                                            _imagemSelecionada,
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () => _tirarFotoCamera(),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt,color:Colors.white),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 4),
                                          child: Text(
                                            "Camera",
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            )
                                          ),
                                        ),
                                      ),
                                    ],
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
                              GestureDetector(
                                onTap: () => _tirarFotoGaleria(),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Row(
                                    children: [
                                      Icon(Icons.insert_photo_rounded,color:Colors.white),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 4),
                                          child: Text(
                                            "Galeria",
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(0, 128, 255, 1),
                                      Color.fromRGBO(51, 153, 255, 1)
                                    ]),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )
                            ],
                          ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            _editarOrdem();
                                          }
                                        },
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(16, 8, 16, 8),
                                          child: Center(
                                            child: Text(
                                              "Enviar chamado",
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                              )
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Color.fromRGBO(0, 128, 255, 1),
                                              Color.fromRGBO(51, 153, 255, 1)
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )))));
  }
}