import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:helpdesk/model/Local.dart';
import 'package:helpdesk/model/Ordem.dart';
import 'package:helpdesk/model/Pessoa.dart';
import 'package:helpdesk/model/Situacao.dart';
import 'package:helpdesk/repository/LocalRepository.dart';
import 'package:helpdesk/repository/OrdemRepository.dart';
import 'package:helpdesk/repository/PessoaRepository.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:validadores/validadores.dart';

class CadastroChamado extends StatefulWidget {
  Pessoa _pessoa;
  CadastroChamado(this._pessoa);
  @override
  _CadastroChamadoState createState() => _CadastroChamadoState();
}

class _CadastroChamadoState extends State<CadastroChamado> {
  File _imagemSelecionada;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  Ordem _ordem = Ordem();
  Local _local = Local.alt();
  final PessoaRepository _repository = PessoaRepository();
  final OrdemRepository _ordemRepository = OrdemRepository();
  final LocalRepository _localRepository = LocalRepository();

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

  _cadastrarOrdem() async {
    _ordem.cliente = widget._pessoa;
    _ordem.dataInicio = DateTime.now().toUtc();
    _ordem.situacao = Situacao.alt(1, "CRIADA");
    _ordem.dataInicio = DateTime.now();
    _ordem.local = _local;
    print(_ordem.toMap());
    print("--------------" + _ordem.toMap().toString());
    if (_imagemSelecionada == null) {
      _ordem.imagem = "sem-imagem.png";
    } else {
      String url = await _repository.enviarFoto(_imagemSelecionada);
      _ordem.imagem = url;
    }
    await _ordemRepository.criarOrdem(_ordem);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Chamado"),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 4, top: 8, right: 4),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: "Titulo",
                            fillColor: Colors.white,
                            icon: Icon(Icons.title, color: Colors.grey)),
                        onSaved: (String titulo) => _ordem.titulo = titulo,
                        validator: (titulo) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo Título é obrigatório ")
                              .valido(titulo);
                        },
                      ),
                      TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: "Descrição",
                            fillColor: Colors.white,
                            icon: Icon(Icons.text_snippet, color: Colors.grey)),
                        onSaved: (String descricao) =>
                            _ordem.descricao = descricao,
                        validator: (descricao) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo Descrição é obrigatório")
                              .valido(descricao);
                        },
                      ),
                          TypeAheadFormField<Local>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _typeAheadController,
                                decoration: InputDecoration(
                                  hintText: "Local",
                                  icon: Icon(Icons.location_pin)
                                )
                              ),
                            transitionBuilder:
                                (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            loadingBuilder: (context) {
                              return Text("Nenhum local encontrado");
                            },
                            itemBuilder: (context, itemData) {
                              return ListTile(
                                title: Text(itemData.local),
                              );
                            },
                            suggestionsCallback: (pattern) async {
                              if (pattern == "") {
                                return await _localRepository.listarLocais();
                              } else {
                                return await _localRepository
                                    .listarLocaisPorPalavra(pattern);
                              }
                            },
                            onSuggestionSelected: (suggestion) {
                              setState(() {
                                this._typeAheadController.text = suggestion.local;
                                _local = suggestion;
                              });
                              _local = suggestion;
                            },
                            onSaved: (newValue) => _local.local = newValue,
                            validator: (value) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: "Campo local é obrigatório")
                                  .valido(value);
                            },
                          ),
                      Container(
                        padding: EdgeInsets.all(16),
                        height: 200,
                        width: 300,
                        child: _imagemSelecionada == null
                            ? Image.asset(
                                "imagens/sem-imagem.png",
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
                          RaisedButton(
                              onPressed: _tirarFotoCamera,
                              child: Row(
                                children: [
                                  Icon(Icons.camera_alt),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text("Camera")
                                ],
                              )),
                          RaisedButton(
                              onPressed: _tirarFotoGaleria,
                              child: Row(
                                children: [
                                  Icon(Icons.insert_photo_rounded),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text("Galeria")
                                ],
                              )),
                        ],
                      ),
                      RaisedButton(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Text(
                            "Enviar Chamado",
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _cadastrarOrdem();
                            }
                          }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
