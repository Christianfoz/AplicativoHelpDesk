import 'package:helpdesk/model/Comentario.dart';
import 'package:helpdesk/util/Dio.dart';
import 'package:helpdesk/util/Ip.dart';

class ComentarioRepository{

  /*

  ------------------------------------


  Métodos utilizando a biblioteca dio para comunicação com o back end


  -------------------------------------

  
  */

  Future<List<Comentario>> listarComentarioPorChamado(int id) async {
    var _dio = CustomDio().instance;
    return await _dio.get(Ip.ip + "comentario/$id").then((value) {
      return value.data.map<Comentario>((b) => Comentario.fromMap(b)).toList()
          as List<Comentario>;
    });
  }

  Future<bool> criarComentario(Comentario c) async {
    var _dio = CustomDio().instance;
    return await _dio
        .post(Ip.ip + "comentario", data: c.toJson())
        .then((value) => value.data);
  }

  }


