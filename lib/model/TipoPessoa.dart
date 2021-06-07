/*

---------------------------------------------------------


Classe TipoPessoa com atributos e métodos


----------------------------------------------------------

*/


import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:helpdesk/model/Pessoa.dart';

class TipoPessoa {
  int idTipoPessoa;
  String nomeTipoPessoa;
  List<Pessoa> pessoas = [];

  TipoPessoa({
    this.idTipoPessoa,
    this.nomeTipoPessoa,
    this.pessoas
  });

  TipoPessoa.alt(
    this.idTipoPessoa,
    this.nomeTipoPessoa
  );
  
  



  Map<String, dynamic> toMap() {
    return {
      'idTipoPessoa': idTipoPessoa,
      'nomeTipoPessoa': nomeTipoPessoa,
      'pessoas': pessoas == null ? null : pessoas?.map((x) => x.toMap())?.toList(),
    };
  }

  factory TipoPessoa.fromMap(Map<String, dynamic> map) {
    return TipoPessoa(
      idTipoPessoa: map['idTipoPessoa'],
      nomeTipoPessoa: map['nomeTipoPessoa'],
      pessoas: null);
  }

  String toJson() => json.encode(toMap());

  factory TipoPessoa.fromJson(String source) => TipoPessoa.fromMap(json.decode(source));

  @override
  String toString() => 'TipoPessoa(idTipoPessoa: $idTipoPessoa, nomeTipoPessoa: $nomeTipoPessoa, pessoas: $pessoas)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TipoPessoa &&
      other.idTipoPessoa == idTipoPessoa &&
      other.nomeTipoPessoa == nomeTipoPessoa &&
      listEquals(other.pessoas, pessoas);
  }

  @override
  int get hashCode => idTipoPessoa.hashCode ^ nomeTipoPessoa.hashCode ^ pessoas.hashCode;
}
