import 'dart:convert';

import 'package:helpdesk/model/Piso.dart';

class Sala {
  int idSala;
  String nomeSala;
  Piso piso;
  Sala({
    this.idSala,
    this.nomeSala,
    this.piso,
  });


  Map<String, dynamic> toMap() {
    return {
      'idSala': idSala,
      'nomeSala': nomeSala,
      'piso': piso.toMap(),
    };
  }

  factory Sala.fromMap(Map<String, dynamic> map) {
    return Sala(
      idSala: map['idSala'],
      nomeSala: map['nomeSala'],
      piso: Piso.fromMap(map['piso']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Sala.fromJson(String source) => Sala.fromMap(json.decode(source));

  @override
  String toString() => 'Sala(idSala: $idSala, nomeSala: $nomeSala, piso: $piso)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Sala &&
      other.idSala == idSala &&
      other.nomeSala == nomeSala &&
      other.piso == piso;
  }

  @override
  int get hashCode => idSala.hashCode ^ nomeSala.hashCode ^ piso.hashCode;
}
