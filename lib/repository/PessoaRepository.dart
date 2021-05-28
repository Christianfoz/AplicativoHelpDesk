
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:helpdesk/model/Pessoa.dart';
import 'package:helpdesk/util/Dio.dart';
import 'package:helpdesk/util/Ip.dart';

class PessoaRepository implements Ip{

  Future<String> enviarFoto(File file) async{
    var _dio = CustomDio().instance;
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
        "image":
            await MultipartFile.fromFile(file.path, filename:fileName),
    });
   return _dio.post(Ip.ip + "pessoa/envioFoto", data: formData).then((value) => value.data);

  }
  
  
  Future<bool> inserirPessoa(Pessoa p) async {
    var _dio = CustomDio().instance;
    return await _dio
        .post("http://192.168.0.105:8080/pessoa", data: p.toJson())
        .then((value) => value.data).onError((error, stackTrace) => false);
    }

    Future<Pessoa> logarPessoa(Pessoa p) async{
      var _dio = CustomDio().instance;
      return await _dio.post("http://192.168.0.105:8080/pessoa/login",data: p.toJsonLogin())
      .then((value) {
        if(value.data == ""){
          return null;
        }
        else{
          return Pessoa.fromMap(value.data);
        }
      } );
    }

    Future<int> verificarQuantidadeChamado(int id) async {
    var _dio = CustomDio().instance;
    return await _dio
        .get("http://192.168.0.105:8080/pessoa/verificacaoChamado/$id")
        .then((value) => value.data);
    }

    Future<Pessoa> verificarEmailECpf(Pessoa p) async{
      var _dio = CustomDio().instance;
      return await _dio.post("http://192.168.0.105:8080/pessoa/verificarEmailECpf",data: p.toMapEsqueciSenha())
      .then((value) {
        if(value.data == ""){
          return null;
        }
        else{
          return Pessoa.fromMap(value.data);
        }
      });
    }

    Future<Pessoa> atualizarSenha(Pessoa p) async{
      var _dio = CustomDio().instance;
      return await _dio.post("http://192.168.0.105:8080/pessoa/atualizarSenha",data: p.toJson())
      .then((value) => Pessoa.fromMap(value.data));
    }
  }