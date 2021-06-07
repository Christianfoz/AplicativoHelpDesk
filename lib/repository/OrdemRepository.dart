import 'package:helpdesk/model/Ordem.dart';
import 'package:helpdesk/util/Dio.dart';

class OrdemRepository {

  /*

  ------------------------------------


  Métodos utilizando a biblioteca dio para comunicação com o back end


  -------------------------------------

  
  */

  //cria ordem


  Future<bool> criarOrdem(Ordem p) async {
    var _dio = CustomDio().instance;
    return await _dio
        .post("http://192.168.0.105:8080/ordem/", data: p.toJson())
        .then((value) => value.data);
  }

  //edita ordem

   Future<bool> editarOrdem(Ordem p) async {
    var _dio = CustomDio().instance;
    return await _dio
        .put("http://192.168.0.105:8080/ordem/", data: p.toJson())
        .then((value) => value.data);
  }

  //atualiza chamado para em andamento

  Future<bool> atualizarEstadoParaEmProgresso(Ordem p) async {
    var _dio = CustomDio().instance;
    return await _dio
        .put("http://192.168.0.105:8080/ordem/atualizaParaEmProgresso",
            data: p.toJson())
        .then((value) => value.data);
  }

  //atualiza chamado para resolvido

  Future<bool> atualizarEstadoParaResolvido(Ordem p) async {
    var _dio = CustomDio().instance;
    return await _dio
        .put("http://192.168.0.105:8080/ordem/atualizaParaResolvido",
            data: p.toJson())
        .then((value) => value.data);
  }

  //lista chamados

  Future<List<Ordem>> listarOrdens() async {
    var _dio = CustomDio().instance;
    return await _dio.get("http://192.168.0.105:8080/ordem").then((value) {
      return value.data.map<Ordem>((b) => Ordem.fromMap(b)).toList()
          as List<Ordem>;
    });
  }

  //lista chamados por situacao

  Future<List<Ordem>> listarOrdensPorSituacao(int id) async {
    var _dio = CustomDio().instance;
    return await _dio
        .get("http://192.168.0.105:8080/ordem/listarPorSituacao/$id")
        .then((value) {
      return value.data.map<Ordem>((b) => Ordem.fromMap(b)).toList()
          as List<Ordem>;
    });
  }

  //lista chamados baseado na palavra pesquisada

  Future<List<Ordem>> listarOrdensPorTitulo(String pesquisa) async {
    var _dio = CustomDio().instance;
    return await _dio
        .get("http://192.168.0.105:8080/ordem/listarPorTitulo/$pesquisa")
        .then((value) {
      return value.data.map<Ordem>((b) => Ordem.fromMap(b)).toList()
          as List<Ordem>;
    });
  }

  //deleta chamado

  Future<bool> deletarChamado(int id) async {
    var _dio = CustomDio().instance;
    return await _dio
        .delete("http://192.168.0.105:8080/ordem/$id")
        .then((value) {
      return value.data;
    });
  }

  //lista chamados criados pelo cliente

  Future<List<Ordem>> listarChamadosCriadosPorPessoa(int id) async {
    var _dio = CustomDio().instance;
    return await _dio
        .get("http://192.168.0.105:8080/ordem/listarChamadosCriadosPorPessoa/$id")
      .then((value) {
      return value.data.map<Ordem>((b) => Ordem.fromMap(b)).toList()
          as List<Ordem>;
    });
  }

  //lista chamados aceitos pelo tecnico

  Future<List<Ordem>> listarChamadosAceitosPorPessoa(int id) async {
    var _dio = CustomDio().instance;
    return await _dio
        .get("http://192.168.0.105:8080/ordem/listarChamadosAceitosPorPessoa/$id")
        .then((value) {
      return value.data.map<Ordem>((b) => Ordem.fromMap(b)).toList()
          as List<Ordem>;
    });
  }
}
