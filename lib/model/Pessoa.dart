import 'dart:convert';

import 'package:helpdesk/model/TipoPessoa.dart';

class Pessoa {
  int idPessoa;
  String nome;
  String sobrenome;
  String cpf;
  String telefone;
  String email;
  String senha;
  String foto;
  TipoPessoa tipoPessoa;
  Pessoa({
    this.idPessoa,
    this.nome,
    this.sobrenome,
    this.cpf,
    this.telefone,
    this.email,
    this.senha,
    this.foto,
    this.tipoPessoa
  });
  

  Map<String, dynamic> toMap() {
    return {
      'idPessoa': idPessoa,
      'nome': nome,
      'sobrenome': sobrenome,
      'cpf': cpf,
      'telefone': telefone,
      'email': email,
      'senha': senha,
      'foto': foto,
      'tipoPessoa': tipoPessoa.toMap(),
    };
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      idPessoa: map['idPessoa'],
      nome: map['nome'],
      sobrenome: map['sobrenome'],
      cpf: map['cpf'],
      telefone: map['telefone'],
      email: map['email'],
      senha: map['senha'],
      foto: map['foto'],
      tipoPessoa: TipoPessoa.fromMap(map['tipoPessoa']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Pessoa.fromJson(String source) => Pessoa.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Pessoa(idPessoa: $idPessoa, nome: $nome, sobrenome: $sobrenome, cpf: $cpf, telefone: $telefone, email: $email, senha: $senha, foto: $foto, tipoPessoa: $tipoPessoa)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Pessoa &&
      other.idPessoa == idPessoa &&
      other.nome == nome &&
      other.sobrenome == sobrenome &&
      other.cpf == cpf &&
      other.telefone == telefone &&
      other.email == email &&
      other.senha == senha &&
      other.foto == foto &&
      other.tipoPessoa == tipoPessoa;
  }

  @override
  int get hashCode {
    return idPessoa.hashCode ^
      nome.hashCode ^
      sobrenome.hashCode ^
      cpf.hashCode ^
      telefone.hashCode ^
      email.hashCode ^
      senha.hashCode ^
      foto.hashCode ^
      tipoPessoa.hashCode;
  }
}
