import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:helpdesk/model/Piso.dart';

class Bloco {
  int idBloco;
  String nomeBloco;
  List<Piso> pisos = [];
  Bloco({
    this.idBloco,
    this.nomeBloco,
    this.pisos,
  });


  Map<String, dynamic> toMap() {
    return {
      'idBloco': idBloco,
      'nomeBloco': nomeBloco,
      'pisos': pisos?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Bloco.fromMap(Map<String, dynamic> map) {
    return Bloco(
      idBloco: map['idBloco'],
      nomeBloco: map['nomeBloco'],
      pisos: List<Piso>.from(map['pisos']?.map((x) => Piso.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bloco.fromJson(String source) => Bloco.fromMap(json.decode(source));

  @override
  String toString() => 'Bloco(idBloco: $idBloco, nomeBloco: $nomeBloco, pisos: $pisos)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Bloco &&
      other.idBloco == idBloco &&
      other.nomeBloco == nomeBloco &&
      listEquals(other.pisos, pisos);
  }

  @override
  int get hashCode => idBloco.hashCode ^ nomeBloco.hashCode ^ pisos.hashCode;
}
