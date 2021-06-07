/*

---------------------------------------------------------


Classe Situação com atributos e métodos


----------------------------------------------------------

*/

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:helpdesk/model/Ordem.dart';

class Situacao {
  int idSituacao;
  String nomeSituacao;
  List<Ordem> ordens = [];
  Situacao({
    this.idSituacao,
    this.nomeSituacao,
    this.ordens
  });

    Situacao.alt(
    this.idSituacao,
    this.nomeSituacao
  );
  

  Map<String, dynamic> toMap() {
    return {
      'idSituacao': idSituacao,
      'nomeSituacao': nomeSituacao,
      'ordens': null,
    };
  }

  factory Situacao.fromMap(Map<String, dynamic> map) {
    return Situacao(
      idSituacao: map['idSituacao'],
      nomeSituacao: map['nomeSituacao'],
      ordens: map['ordens'] == null ? null : List<Ordem>.from(map['ordens']?.map((x) => Ordem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Situacao.fromJson(String source) => Situacao.fromMap(json.decode(source));

  @override
  String toString() => 'Situacao(idSituacao: $idSituacao, nomeSituacao: $nomeSituacao, ordens: $ordens)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Situacao &&
      other.idSituacao == idSituacao &&
      other.nomeSituacao == nomeSituacao &&
      listEquals(other.ordens, ordens);
  }

  @override
  int get hashCode => idSituacao.hashCode ^ nomeSituacao.hashCode ^ ordens.hashCode;
}
