import 'package:flutter/material.dart';
import 'package:helpdesk/model/Bloco.dart';
import 'package:helpdesk/model/Ordem.dart';
import 'package:helpdesk/model/Pessoa.dart';
import 'package:helpdesk/model/Piso.dart';
import 'package:helpdesk/model/Sala.dart';
import 'package:helpdesk/model/Situacao.dart';
import 'package:helpdesk/repository/BlocoRepository.dart';
import 'package:helpdesk/repository/PisoRepository.dart';
import 'package:helpdesk/repository/SalaRepository.dart';
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
  Ordem _ordem = Ordem();
  final _blocoRepository = BlocoRepository();
  final _pisoRepository = PisoRepository();
  final _salaRepository = SalaRepository();
  List<Bloco> _blocos;
  List<Piso> _pisos;
  List<Sala> _salas;
  int _idBloco;
  int _idPiso;


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

  _cadastrarOrdem() {
    _ordem.cliente = widget._pessoa;
    _ordem.dataInicio = DateTime.now();
    _ordem.situacao = Situacao.alt(1, "CRIADA");
  }

  Future<List<Bloco>>_listarBlocos() async{
    _blocos = await _blocoRepository.listarBlocos();
    return _blocos;
  }

  Future<List<Piso>> _listarPisoPorBloco(int id) async{
    _pisos = await _pisoRepository.listarPisosPorBloco(id);
    return _pisos;
  }

  Future<List<Sala>> _listarSalasPorPiso(int id) async{
    _salas = await _salaRepository.listarSalasPorPiso(id);
    return _salas;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listarBlocos();
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
                            icon: Icon(Icons.person)),
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
                            icon: Icon(Icons.person)),
                        onSaved: (String descricao) =>
                            _ordem.descricao = descricao,
                        validator: (descricao) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo Descrição é obrigatório")
                              .valido(descricao);
                        },
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 8, top: 24),
                            child: Icon(
                            Icons.apartment,
                            color: Colors.grey,),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 4,top: 24),
                            child: Text("Bloco",style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey
                            ),)
                          ),
                          Container(
                            width: 200,
                            padding: EdgeInsets.only(left: 8, top: 24),
                            child: FutureBuilder<List<Bloco>>(
                            builder: (context, AsyncSnapshot<List<Bloco>> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return CircularProgressIndicator();
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  if(!snapshot.hasData){
                                    return Text("Sem blocos");
                                  }
                                  else if(snapshot.hasData){
                                    return DropdownButtonFormField(
                                      onChanged: (Bloco bloco) {
                                        setState(() {
                                          _idBloco = bloco.idBloco;
                                          _listarPisoPorBloco(_idBloco);
                                        });
                                      },
                                      validator: (value) {
                                        return Validador()
                                        .add(Validar.OBRIGATORIO,msg: "Campo Bloco é obrigatório")
                                        .valido(value);
                                      },
                                      items: snapshot.data.map<DropdownMenuItem<Bloco>>((Bloco bloco){
                                        return DropdownMenuItem<Bloco>(
                                          value: bloco,
                                          child: Text(bloco.nomeBloco),
                                        );
                                      }).toList());
                                  }
                                  
                              }
                              return Text('No slide availabe.');
                            },
                            future: _listarBlocos(),
                          ),
                          )
                          
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 8, top: 24),
                            child: Icon(
                            Icons.elevator,
                            color: Colors.grey,),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 4,top: 24),
                            child: Text("Piso",style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey
                            ),)
                          ),
                          Container(
                            width: 200,
                            padding: EdgeInsets.only(left: 8, top: 24),
                            child: FutureBuilder(
                            future: _listarPisoPorBloco(_idBloco),
                            builder: (context, AsyncSnapshot<List<Piso>> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return CircularProgressIndicator();
                                  break;
                                case ConnectionState.done:
                                  if(snapshot.hasData){
                                    return DropdownButtonFormField(
                                      onChanged: (Piso piso) {
                                        setState(() {
                                          _idPiso = piso.idPiso;
                                          _listarSalasPorPiso(_idPiso);
                                        });
                                      },
                                      validator: (value) {
                                        return Validador()
                                        .add(Validar.OBRIGATORIO,msg: "Campo Piso é obrigatório")
                                        .valido(value);
                                      },
                                      items: snapshot.data.map<DropdownMenuItem<Piso>>((Piso piso){
                                        return DropdownMenuItem<Piso>(
                                          value: piso,
                                          child: Text(piso.nomePiso),
                                        );
                                      }).toList());
                                  }
                                  else if(!snapshot.hasData){
                                    return Container();
                                  }
                                break;
                                default:
                              }
                              return Container();
                            },
                            
                          ),
                          )
                          
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 8, top: 24),
                            child: Icon(
                            Icons.meeting_room,
                            color: Colors.grey,),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 4,top: 24),
                            child: Text("Sala",style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey
                            ),)
                          ),
                          Container(
                            width: 200,
                            padding: EdgeInsets.only(left : 8, top: 24),
                            child: FutureBuilder(
                            future: _listarSalasPorPiso(_idPiso),
                            builder: (context, AsyncSnapshot<List<Sala>> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return CircularProgressIndicator();
                                  break;
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  if(snapshot.hasData){
                                    return DropdownButtonFormField(
                                      onChanged: (Sala sala) {
                                        setState(() {
                                          
                                        });
                                      },
                                      validator: (value) {
                                        return Validador()
                                        .add(Validar.OBRIGATORIO,msg: "Campo Sala é obrigatório")
                                        .valido(value);
                                      },
                                      items: snapshot.data.map<DropdownMenuItem<Sala>>((Sala sala){
                                        return DropdownMenuItem<Sala>(
                                          value: sala,
                                          child: Text(sala.nomeSala),
                                        );
                                      }).toList());
                                  }
                                  else if(!snapshot.hasData){
                                    return Container();
                                  }
                                break;
                              }
                              return Container();
                            },
                            
                          ),
                          )
                          
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        height: 200,
                        width: 300,
                        child: _imagemSelecionada == null
                            ? Image.asset(
                                "imagens/sem-foto.png",
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