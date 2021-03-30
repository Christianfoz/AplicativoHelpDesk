import 'dart:convert';

import 'Ordem.dart';

class Local {
  int idLocal;
  String local;
  List<Ordem> ordens;
  Local({
    this.idLocal,
    this.local,
    this.ordens,
  });

  Local.alt({
    this.idLocal,
    this.local,
  });


  Map<String, dynamic> toMap() {
    return {
      'idLocal': idLocal,
      'local': local,
      'ordens': null,
    };
  }

  factory Local.fromMap(Map<String, dynamic> map) {
    return Local(
      idLocal: map['idLocal'],
      local: map['local'],
      ordens: null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Local.fromJson(String source) => Local.fromMap(json.decode(source));

}
