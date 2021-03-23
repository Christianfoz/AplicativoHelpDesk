import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  _cadastrarPessoa() async{
    if(_switch){
      _pessoa.tipoPessoa = TipoPessoa.alt(2,"Técnico");
    }
    else{
      _pessoa.tipoPessoa = TipoPessoa.alt(1,"Cliente");
    }
    if(_imagemSelecionada == null){
      _pessoa.foto = "sem-foto.png";
    }
    else{
      String url = await _repository.enviarFoto(_imagemSelecionada);
      _pessoa.foto = url;
    }
    await _repository.inserirPessoa(_pessoa);
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
        title: Text("Cadastro"),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                height: 200,
                width: 200,
                child: _imagemSelecionada == null
                    ? Image.asset("imagens/avatar.png",fit: BoxFit.fill,)
                    : Image.file(_imagemSelecionada,fit: BoxFit.fill,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                      onPressed: _tirarFotoCamera, child: Row(
                        children: [
                          Icon(Icons.camera_alt),
                          SizedBox(
                            width: 2,
                          ),
                          Text("Camera")
                          ],
                      )
                  ),
                  RaisedButton(
                      onPressed: _tirarFotoGaleria, child: Row(
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
              Container(
                padding: EdgeInsets.only(left: 4, top: 8,right: 4),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(

                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(hintText: "Nome",fillColor: Colors.white,icon: Icon(Icons.person)),
                        onSaved: (String nome) => _pessoa.nome = nome,
                        validator: (nome) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo Nome é obrigatório ")
                              .minLength(4,msg: "Minimo 4 caracteres ")
                              .maxLength(20,msg: "Máximo 20 caracteres ")
                              .valido(nome);
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(hintText: "Sobrenome",fillColor: Colors.white,icon: Icon(Icons.person)),
                        onSaved: (String sobrenome) => _pessoa.sobrenome = sobrenome,
                        validator: (sobrenome) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo Sobrenome é obrigatório")
                              .maxLength(50,msg: "Máximo 50 caracteres")
                              .valido(sobrenome);
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        onSaved: (String cpf) => _pessoa.cpf = cpf,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CpfInputFormatter()
                        ],
                        decoration: InputDecoration(hintText: "CPF",fillColor: Colors.white,icon: Icon(Icons.account_box_outlined)),
                        validator: (cpf) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo CPF é obrigatório ")
                              .add(Validar.CPF, msg: "CPF inválido ")
                              .valido(cpf);
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        onSaved: (String telefone) => _pessoa.telefone = telefone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter()
                        ],
                        decoration: InputDecoration(hintText: "Telefone",fillColor: Colors.white,icon: Icon(Icons.phone)),
                        validator: (telefone) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo Telefone é obrigatório ")
                              .valido(telefone);
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String email) => _pessoa.email = email,
                        decoration: InputDecoration(hintText: "E-mail",fillColor: Colors.white,icon: Icon(Icons.email)),
                        validator: (email) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo obrigatório ")
                              .add(Validar.EMAIL, msg: "Email inválido ")
                              .minLength(10,msg:"Mínimo 10 caracteres ")
                              .maxLength(50,msg:"Máximo 50 caracteres ")
                              .valido(email);
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String senha) => _pessoa.senha = senha,
                        obscureText: true,
                        decoration: InputDecoration(hintText: "Senha",fillColor: Colors.white,icon: Icon(Icons.lock)),
                        validator: (senha) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo Senha é obrigatório ")
                              .minLength(6,msg: "Mínimo 6 caracteres ")
                              .maxLength(8,msg: "Máximo 8 caracteres ")
                              .valido(senha);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Cliente"),
                          Switch(
                              value: _switch,
                              onChanged: (status) {
                                setState(() {
                                  _switch = status;
                                });
                              }),
                          Text("Técnico")
                        ],
                      ),
                      RaisedButton(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Text(
                            "Cadastrar",
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _cadastrarPessoa();
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

