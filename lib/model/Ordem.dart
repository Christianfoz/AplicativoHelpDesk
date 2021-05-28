import 'dart:convert';

import 'package:helpdesk/model/Local.dart';
import 'package:helpdesk/model/Pessoa.dart';
import 'package:helpdesk/model/Situacao.dart';

class Ordem {
  int idOrdem;
  String titulo;
  String descricao;
  String solucao;
  String imagem;
  DateTime dataInicio;
  DateTime dataTermino;
  Situacao situacao;
  Pessoa cliente;
  Pessoa tecnico;
  Local local;
  bool status;
  Ordem({
    this.idOrdem,
    this.titulo,
    this.descricao,
    this.solucao,
    this.imagem,
    this.dataInicio,
    this.dataTermino,
    this.situacao,
    this.cliente,
    this.tecnico,
    this.local,
    this.status
  });

  Map<String, dynamic> toMap() {
    return {
      'idOrdem': idOrdem,
      'titulo': titulo,
      'descricao': descricao,
      'solucao': solucao,
      'dataInicio': dataInicio.toUtc().toIso8601String(),
      'dataTermino': dataTermino == null ? null: dataTermino.millisecondsSinceEpoch,
      'imagem': imagem,
      'situacao': situacao.toMap(),
      'cliente': cliente.toMap(),
      'tecnico': tecnico == null? null: tecnico.toMap(),
      'local': local.toMap(),
      'status': status
    };
  }

  factory Ordem.fromMap(Map<String, dynamic> map) {
    return Ordem(
      idOrdem: map['idOrdem'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      solucao: map['solucao'] == null ? null : map['solucao'],
      imagem: map['imagem'],
      dataInicio: map['dataInicio'] == null ? null: DateTime.parse(map['dataInicio']).toLocal(),
      dataTermino: map['dataTermino'] == null ? null: DateTime.parse(map['dataTermino']).toLocal(),
      situacao: Situacao.fromMap(map['situacao']),
      cliente: Pessoa.fromMap(map['cliente']),
      tecnico: map['tecnico'] == null ? null : Pessoa.fromMap(map['tecnico']),
      local: Local.fromMap(map['local']),
      status: map['status'] == null ? null : map['status']
    );
  }

  String toJson() => json.encode(toMap());

  factory Ordem.fromJson(String source) => Ordem.fromMap(json.decode(source));
}
