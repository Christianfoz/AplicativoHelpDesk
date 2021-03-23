import 'dart:convert';

import 'package:helpdesk/model/Bloco.dart';
import 'package:helpdesk/model/Pessoa.dart';
import 'package:helpdesk/model/Piso.dart';
import 'package:helpdesk/model/Sala.dart';
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
  Bloco bloco;
  Sala sala;
  Piso piso;
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
    this.bloco,
    this.sala,
    this.piso,
  });

 

  Map<String, dynamic> toMap() {
    return {
      'idOrdem': idOrdem,
      'titulo': titulo,
      'descricao': descricao,
      'solucao': solucao,
      'imagem': imagem,
      'dataInicio': dataInicio.millisecondsSinceEpoch,
      'dataTermino': dataTermino.millisecondsSinceEpoch,
      'situacao': situacao.toMap(),
      'cliente': cliente.toMap(),
      'tecnico': tecnico.toMap(),
      'bloco': bloco.toMap(),
      'sala': sala.toMap(),
      'piso': piso.toMap(),
    };
  }

  factory Ordem.fromMap(Map<String, dynamic> map) {
    return Ordem(
      idOrdem: map['idOrdem'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      solucao: map['solucao'],
      imagem: map['imagem'],
      dataInicio: DateTime.fromMillisecondsSinceEpoch(map['dataInicio']),
      dataTermino: DateTime.fromMillisecondsSinceEpoch(map['dataTermino']),
      situacao: Situacao.fromMap(map['situacao']),
      cliente: Pessoa.fromMap(map['cliente']),
      tecnico: Pessoa.fromMap(map['tecnico']),
      bloco: Bloco.fromMap(map['bloco']),
      sala: Sala.fromMap(map['sala']),
      piso: Piso.fromMap(map['piso']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Ordem.fromJson(String source) => Ordem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Ordem(idOrdem: $idOrdem, titulo: $titulo, descricao: $descricao, solucao: $solucao, imagem: $imagem, dataInicio: $dataInicio, dataTermino: $dataTermino, situacao: $situacao, cliente: $cliente, tecnico: $tecnico, bloco: $bloco, sala: $sala, piso: $piso)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Ordem &&
      other.idOrdem == idOrdem &&
      other.titulo == titulo &&
      other.descricao == descricao &&
      other.solucao == solucao &&
      other.imagem == imagem &&
      other.dataInicio == dataInicio &&
      other.dataTermino == dataTermino &&
      other.situacao == situacao &&
      other.cliente == cliente &&
      other.tecnico == tecnico &&
      other.bloco == bloco &&
      other.sala == sala &&
      other.piso == piso;
  }

  @override
  int get hashCode {
    return idOrdem.hashCode ^
      titulo.hashCode ^
      descricao.hashCode ^
      solucao.hashCode ^
      imagem.hashCode ^
      dataInicio.hashCode ^
      dataTermino.hashCode ^
      situacao.hashCode ^
      cliente.hashCode ^
      tecnico.hashCode ^
      bloco.hashCode ^
      sala.hashCode ^
      piso.hashCode;
  }
}
