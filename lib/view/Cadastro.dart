import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:helpdesk/main.dart';
import 'package:helpdesk/model/Pessoa.dart';
import 'package:helpdesk/model/TipoPessoa.dart';
import 'package:helpdesk/repository/PessoaRepository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validadores/validadores.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  File _imagemSelecionada;
  final _formKey = GlobalKey<FormState>();
  bool _switch = false;
  Pessoa _pessoa = Pessoa();
  final PessoaRepository _repository = PessoaRepository();

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
              Container(child: Text("Cadastrando")),
            ],
          ),
        );
      },
    );
  }

  _cadastrarPessoa() async {
    if (_switch) {
      _pessoa.tipoPessoa = TipoPessoa.alt(2, "Técnico");
    } else {
      _pessoa.tipoPessoa = TipoPessoa.alt(1, "Cliente");
    }
    if (_imagemSelecionada == null) {
      _pessoa.foto = "sem-foto.png";
    } else {
      _mostrarDialogEsperando(context);
      String url = await _repository.enviarFoto(_imagemSelecionada);
      _pessoa.foto = url;
      await _repository.inserirPessoa(_pessoa);
      Navigator.pop(context);
    }
     _mostrarDialogEsperando(context);
    await _repository.inserirPessoa(_pessoa);
    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Cadastro",),
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
                            padding: EdgeInsets.all(16),
                            height: 200,
                            width: 200,
                            child: _imagemSelecionada == null
                                ? Image.asset(
                                    "imagens/avatar.png",
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
                                        child: Text(
                                          "Camera",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
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
                                        child: Text(
                                          "Galeria",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
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
                          Container(
                            padding: EdgeInsets.only(left: 4, top: 8, right: 4),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: TextFormField(
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xff0088cc),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        prefixIcon: Icon(Icons.person),
                                        labelText: "Nome",
                                      ),
                                      onSaved: (String nome) =>
                                          _pessoa.nome = nome,
                                      validator: (nome) {
                                        return Validador()
                                            .add(Validar.OBRIGATORIO,
                                                msg:
                                                    "Campo Nome é obrigatório ")
                                            .minLength(4,
                                                msg: "Minimo 4 caracteres ")
                                            .maxLength(20,
                                                msg: "Máximo 20 caracteres ")
                                            .valido(nome);
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xff0088cc),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        prefixIcon: Icon(Icons.person),
                                        labelText: "Sobrenome",
                                      ),
                                      onSaved: (String sobrenome) =>
                                          _pessoa.sobrenome = sobrenome,
                                      validator: (sobrenome) {
                                        return Validador()
                                            .add(Validar.OBRIGATORIO,
                                                msg:
                                                    "Campo Sobrenome é obrigatório")
                                            .maxLength(50,
                                                msg: "Máximo 50 caracteres")
                                            .valido(sobrenome);
                                      },
                                    ),
                                    padding: EdgeInsets.all(8),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      onSaved: (String cpf) =>
                                          _pessoa.cpf = cpf,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        CpfInputFormatter()
                                      ],
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xff0088cc),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        prefixIcon:
                                            Icon(Icons.account_box_outlined),
                                        labelText: "CPF",
                                      ),
                                      validator: (cpf) {
                                        return Validador()
                                            .add(Validar.OBRIGATORIO,
                                                msg: "Campo CPF é obrigatório ")
                                            .add(Validar.CPF,
                                                msg: "CPF inválido ")
                                            .valido(cpf);
                                      },
                                    ),
                                    padding: EdgeInsets.all(8),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      onSaved: (String telefone) =>
                                          _pessoa.telefone = telefone,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        TelefoneInputFormatter()
                                      ],
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xff0088cc),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        prefixIcon: Icon(Icons.phone),
                                        labelText: "Telefone",
                                      ),
                                      validator: (telefone) {
                                        return Validador()
                                            .add(Validar.OBRIGATORIO,
                                                msg:
                                                    "Campo Telefone é obrigatório ")
                                            .valido(telefone);
                                      },
                                    ),
                                    padding: EdgeInsets.all(8),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xff0088cc),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        prefixIcon: Icon(Icons.email),
                                        labelText: "E-mail",
                                      ),
                                      onSaved: (email) => _pessoa.email = email,
                                      validator: (valorEmail) {
                                        return Validador()
                                            .add(Validar.EMAIL,
                                                msg: "Insira um e-mail válido")
                                            .add(Validar.OBRIGATORIO,
                                                msg:
                                                    "Insira seu e-mail de acesso")
                                            .maxLength(50,
                                                msg:
                                                    "Email deve ter menos de 50 caracteres")
                                            .valido(valorEmail);
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xff0088cc),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        prefixIcon: Icon(Icons.lock),
                                        labelText: "Senha",
                                      ),
                                      obscureText: true,
                                      onSaved: (senha) => _pessoa.senha = senha,
                                      validator: (valorSenha) {
                                        return Validador()
                                            .add(Validar.OBRIGATORIO,
                                                msg: "Insira sua senha")
                                            .maxLength(8,
                                                msg:
                                                    "Senha deve ter menos de 8 caracteres")
                                            .valido(valorSenha);
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text("Cliente"),
                                        padding: EdgeInsets.all(8),
                                      ),
                                      FlutterSwitch(
                                        width: 55.0,
                                        height: 25.0,
                                        valueFontSize: 12.0,
                                        toggleSize: 18.0,
                                        value: _switch,
                                        onToggle: (val) {
                                          setState(() {
                                            _switch = val;
                                          });
                                        },
                                      ),
                                      /*
                                      Switch(

                                          value: _switch,
                                          onChanged: (status) {
                                            setState(() {
                                              _switch = status;
                                            });
                                          }),
                                          */
                                      Container(
                                        child: Text("Técnico"),
                                        padding: EdgeInsets.all(8),
                                      ),
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
                                            _cadastrarPessoa();
                                          }
                                        },
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(16, 8, 16, 8),
                                          child: Center(
                                            child: Text(
                                              "Cadastrar",
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
