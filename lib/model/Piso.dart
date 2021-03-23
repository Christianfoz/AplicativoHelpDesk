import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:helpdesk/model/Bloco.dart';
import 'package:helpdesk/model/Sala.dart';

class Piso {
  int idPiso;
  String nomePiso;
  Bloco bloco;
  List<Sala> salas = [];
  Piso({
    this.idPiso,
    this.nomePiso,
    this.bloco,
    this.salas,
  });


  Map<String, dynamic> toMap() {
    return {
      'idPiso': idPiso,
      'nomePiso': nomePiso,
      'bloco': bloco.toMap(),
      'salas': salas?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Piso.fromMap(Map<String, dynamic> map) {
    return Piso(
      idPiso: map['idPiso'],
      nomePiso: map['nomePiso'],
      bloco: Bloco.fromMap(map['bloco']),
      salas: List<Sala>.from(map['salas']?.map((x) => Sala.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Piso.fromJson(String source) => Piso.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Piso(idPiso: $idPiso, nomePiso: $nomePiso, bloco: $bloco, salas: $salas)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Piso &&
      other.idPiso == idPiso &&
      other.nomePiso == nomePiso &&
      other.bloco == bloco &&
      listEquals(other.salas, salas);
  }

  @override
  int get hashCode {
    return idPiso.hashCode ^
      nomePiso.hashCode ^
      bloco.hashCode ^
      salas.hashCode;
  }
}
