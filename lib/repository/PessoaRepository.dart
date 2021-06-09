
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:helpdesk/model/Pessoa.dart';
import 'package:helpdesk/util/Dio.dart';
import 'package:helpdesk/util/Ip.dart';

class PessoaRepository implements Ip{

    /*

  ------------------------------------


  Métodos utilizando a biblioteca dio para comunicação com o back end


  -------------------------------------

  
  */

  // envia foto para o back end, retorna url para salvar no banco

  Future<String> enviarFoto(File file) async{
    var _dio = CustomDio().instance;
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
        "image":
            await MultipartFile.fromFile(file.path, filename:fileName),
    });
   return _dio.post(Ip.ip + "pessoa/envioFoto", data: formData).then((value) => value.data);

  }
  
  // cadastra pessoa
  
  Future<bool> inserirPessoa(Pessoa p) async {
    var _dio = CustomDio().instance;
    return await _dio
        .post(Ip.ip + "pessoa", data: p.toJson())
        .then((value) => value.data).onError((error, stackTrace) => false);
    }

  // faz login


    Future<Pessoa> logarPessoa(Pessoa p) async{
      var _dio = CustomDio().instance;
      return await _dio.post(Ip.ip + "pessoa/login",data: p.toJsonLogin())
      .then((value) {
        if(value.data == ""){
          return null;
        }
        else{
          return Pessoa.fromMap(value.data);
        }
      } );
    }

    //verifica quantos chamados o técnico tem em andamento. Usada ao aceitar chamado

    Future<int> verificarQuantidadeChamado(int id) async {
    var _dio = CustomDio().instance;
    return await _dio
        .get(Ip.ip + "pessoa/verificacaoChamado/$id")
        .then((value) => value.data);
    }

    //verifica email e cpf do usuário quando ele quer gerar uma nova senha. Utilizado na tela de esqueci minha senha

    Future<Pessoa> verificarEmailECpf(Pessoa p) async{
      var _dio = CustomDio().instance;
      return await _dio.post(Ip.ip + "pessoa/verificarEmailECpf",data: p.toMapEsqueciSenha())
      .then((value) {
        if(value.data == ""){
          return null;
        }
        else{
          return Pessoa.fromMap(value.data);
        }
      });
    }

    // atualiza senha no banco

    Future<Pessoa> atualizarSenha(Pessoa p) async{
      var _dio = CustomDio().instance;
      return await _dio.post(Ip.ip + "pessoa/atualizarSenha",data: p.toJson())
      .then((value) => Pessoa.fromMap(value.data));
    }
  }