import 'dart:convert';

/*

---------------------------------------------------------


Classe Comentario com atributos e métodos


----------------------------------------------------------

*/

import 'package:helpdesk/model/Pessoa.dart';
import 'Ordem.dart';

class Comentario {
    int idComentario;
    String comentario;
    Pessoa criadorComentario;
    DateTime dataComentario;
    Ordem ordem;

  Comentario({
    this.idComentario,
    this.comentario,
    this.criadorComentario,
    this.dataComentario,
    this.ordem,
  });

  Map<String, dynamic> toMap() {
    return {
      'idComentario': idComentario,
      'comentario': comentario,
      'criadorComentario': criadorComentario.toMap(),
      'dataComentario': dataComentario.toUtc().toIso8601String(),
      'ordem': ordem.toMap(),
    };
  }

  factory Comentario.fromMap(Map<String, dynamic> map) {
    return Comentario(
      idComentario: map['idComentario'],
      comentario: map['comentario'],
      criadorComentario: Pessoa.fromMap(map['criadorComentario']),
      dataComentario: map['dataComentario'] == null ? null: DateTime.parse(map['dataComentario']).toLocal(),
      ordem: Ordem.fromMap(map['ordem']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comentario.fromJson(String source) => Comentario.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comentario(idComentario: $idComentario, comentario: $comentario, criadorComentario: $criadorComentario, dataComentario: $dataComentario, ordem: $ordem)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Comentario &&
      other.idComentario == idComentario &&
      other.comentario == comentario &&
      other.criadorComentario == criadorComentario &&
      other.dataComentario == dataComentario &&
      other.ordem == ordem;
  }

  @override
  int get hashCode {
    return idComentario.hashCode ^
      comentario.hashCode ^
      criadorComentario.hashCode ^
      dataComentario.hashCode ^
      ordem.hashCode;
  }
}
