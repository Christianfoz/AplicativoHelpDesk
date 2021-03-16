import 'package:flutter/material.dart';
import 'package:helpdesk/main.dart';
import 'package:validadores/Validador.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: themeData.primaryColor,
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 10),
                  child: Text("Helpdesk"),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (email) => null,
                          validator: (valorEmail) {
                            return Validador()
                                .add(Validar.EMAIL,
                                    msg: "Insira um e-mail válido\n\n")
                                .add(Validar.OBRIGATORIO,
                                    msg: "Insira seu e-mail de acesso\n\n")
                                .maxLength(50,
                                    msg:
                                        "Email deve ter menos de 50 caracteres\n\n")
                                .valido(valorEmail);
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          onSaved: (senha) => null,
                          validator: (valorSenha) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Insira sua senha\n\n")
                                .maxLength(8,
                                    msg: "Senha deve ter menos de 8 caracteres\n\n")
                                .valido(valorSenha);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: Column(
                              children: [
                                Padding(
                                    child: GestureDetector(
                                      child: Text(
                                          "Não tem conta? Clique aqui para criar uma"),
                                      onTap: () => Navigator.pushNamed(
                                          context, "/cadastro"),
                                    ),
                                    padding:
                                        EdgeInsets.only(top: 8, bottom: 8)),
                                GestureDetector(
                                  child:
                                      Text("Esqueceu sua senha? Clique aqui"),
                                  onTap: () {},
                                ),
                                ElevatedButton(
                                  child: Text("Entrar"),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      //salva campos
                                      _formKey.currentState.save();
                                      //criar um objeto pessoa e chamar metodo pra logar da api
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
