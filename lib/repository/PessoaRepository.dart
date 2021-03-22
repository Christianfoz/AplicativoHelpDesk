
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:helpdesk/model/Pessoa.dart';
import 'package:helpdesk/util/Dio.dart';

class PessoaRepository {

  Future<String> enviarFoto(File file) async{
    var _dio = CustomDio().instance;
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
        "image":
            await MultipartFile.fromFile(file.path, filename:fileName),
    });
   return _dio.post("http://192.168.0.107:8080/pessoa/envioFoto", data: formData).then((value) => value.data);

  }
  
  
  Future<bool> inserirPessoa(Pessoa p) async {
    var _dio = CustomDio().instance;
    return await _dio
        .post("http://192.168.0.107:8080/pessoa", data: p.toJson())
        .then((value) => value.data);
    }

    Future<Pessoa> logarPessoa(Pessoa p) async{
      var _dio = CustomDio().instance;
      return await _dio.post("http://192.168.0.107:8080/pessoa/login",data: p.toJsonLogin())
      .then((value) => Pessoa.fromMap(value.data));
    }
  }

