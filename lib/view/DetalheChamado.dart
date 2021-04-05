import 'package:flutter/material.dart';
import 'package:helpdesk/util/PessoaOrdem.dart';
import 'package:intl/intl.dart';

class DetalheChamado extends StatefulWidget {
  PessoaOrdem _pessoaOrdem;
  DetalheChamado(this._pessoaOrdem);
  @override
  _DetalheChamadoState createState() => _DetalheChamadoState();
}

class _DetalheChamadoState extends State<DetalheChamado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhes do chamado")),
      body: Container(
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
                  padding: const EdgeInsets.only(right: 4, bottom: 8),
                  child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "http://192.168.0.107:8080/${widget._pessoaOrdem.ordem.cliente.foto}"),
                      radius: 40),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    widget._pessoaOrdem.ordem.cliente.nome +
                        " " +
                        widget._pessoaOrdem.ordem.cliente.sobrenome,
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
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
                        DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br')
                            .format(widget._pessoaOrdem.ordem.dataInicio) +
                        " as " +
                        DateFormat('HH:mm', 'pt_Br')
                            .format(widget._pessoaOrdem.ordem.dataInicio),
                    maxLines: 1,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
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
                  child: widget._pessoaOrdem.ordem.imagem == "sem-imagem.png"
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
            widget._pessoaOrdem.pessoa.tipoPessoa.nomeTipoPessoa == "Técnico"
                ? Row(children: <Widget>[
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
                  ])
                : Container(),
            widget._pessoaOrdem.ordem.situacao.nomeSituacao == "Criada" ? Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Center(
                child: GestureDetector(
                  onTap: () => print("Calma lá que já chego"),
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
            ) : widget._pessoaOrdem.ordem.situacao.nomeSituacao == "Em andamento" ? Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Center(
                child: GestureDetector(
                  onTap: () => print("Calma lá que já chego"),
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
            ) : Container()
          ],
        ),
      ),
    );
  }
}
