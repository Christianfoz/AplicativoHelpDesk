import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpdesk/main.dart';
import 'package:helpdesk/model/Pessoa.dart';
import 'package:helpdesk/repository/PessoaRepository.dart';
import 'package:validadores/Validador.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  Pessoa _pessoa = Pessoa();
  final PessoaRepository _repository = PessoaRepository();

  /*------------------------------------------------------------------------------------


  Dialog de espera quando é realizado login


  ------------------------------------------------------------------------------------

  */

  _mostrarDialogEsperando(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  "Entrando no sistema",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 14)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  /*------------------------------------------------------------------------------------


  Dialog caso de algum erro na realização do login


  ------------------------------------------------------------------------------------

  */

  _dialogErro() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Erro ao realizar login no sistema",
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
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
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  "Email e/ou senha incorretos.Caso seja técnico, seu cadastro ainda não foi validado",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 14)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  /*------------------------------------------------------------------------------------


  Método para logar. Chamado quando o formulário é validado


  ------------------------------------------------------------------------------------

  */

  _login() async {
    Pessoa p = await _repository.logarPessoa(_pessoa);
    if (p == null) {
      _dialogErro();
    } else {
      _mostrarDialogEsperando(context);
      Navigator.pop(context);
      if (p.tipoPessoa.nomeTipoPessoa == "Cliente") {
        Navigator.pushNamedAndRemoveUntil(
            context, "/homecliente", (Route<dynamic> route) => false,
            arguments: p);
      } else if (p.tipoPessoa.nomeTipoPessoa == "Técnico") {
        Navigator.pushNamedAndRemoveUntil(
            context, "/hometecnico", (Route<dynamic> route) => false,
            arguments: p);
      }
    }
  }

/*------------------------------------------------------------------------------------


  Método para criar a tela


  ------------------------------------------------------------------------------------

  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: themeData.primaryColor,
        padding: EdgeInsets.all(16),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 15, spreadRadius: 4)
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 10),
                    child: Text(
                      "Helpdesk",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.lato(),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xff0088cc), width: 2),
                                  borderRadius: BorderRadius.circular(2),
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
                                        msg: "Insira seu e-mail de acesso")
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
                                labelStyle: GoogleFonts.lato(),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xff0088cc), width: 2),
                                  borderRadius: BorderRadius.circular(2),
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
                                    .minLength(6,
                                        msg:
                                            "Senha deve ter de 6 caracteres ou mais")
                                    .valido(valorSenha);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                                child: Column(children: [
                              Padding(
                                  child: GestureDetector(
                                    child: Text(
                                      "Não tem conta? Clique aqui para criar uma",
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle()),
                                    ),
                                    onTap: () => Navigator.pushNamed(
                                        context, "/cadastro"),
                                  ),
                                  padding: EdgeInsets.only(top: 8, bottom: 8)),
                              GestureDetector(
                                child: Text(
                                  "Esqueceu sua senha? Clique aqui",
                                  style: GoogleFonts.lato(),
                                ),
                                onTap: () => Navigator.pushNamed(
                                    context, "/esquecisenha"),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        _login();
                                      }
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(16, 8, 16, 8),
                                      child: Center(
                                        child: Text(
                                          "Entrar",
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
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ])),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
