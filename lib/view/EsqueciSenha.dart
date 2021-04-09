import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpdesk/main.dart';
import 'package:helpdesk/model/Pessoa.dart';
import 'package:validadores/validadores.dart';

class EsqueciSenha extends StatefulWidget {
  @override
  _EsqueciSenhaState createState() => _EsqueciSenhaState();
}

class _EsqueciSenhaState extends State<EsqueciSenha> {
  final _globalKey = GlobalKey<FormState>();
  Pessoa _pessoa;

  _recuperacaoSenha(){

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
          title: Text(
            "Esqueci minha senha",
            style: GoogleFonts.lato(),
            ),
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
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Insira CPF e Email para a geração de uma nova senha",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              )
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ),
                        Form(
                          key: _globalKey,
                          child: Column(
                            children: [
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
                                        labelStyle: GoogleFonts.lato(),
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
                                    padding: EdgeInsets.all(8),
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelStyle: GoogleFonts.lato(),
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
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 20,left: 20, right: 20),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (_globalKey.currentState
                                              .validate()) {
                                            _globalKey.currentState.save();
                                            _recuperacaoSenha();
                                          }
                                        },
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(16, 8, 16, 8),
                                          child: Center(
                                            child: Text(
                                              "Enviar Dados",
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
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    )
                  )
                )
              )
            )
          );
  }
}
