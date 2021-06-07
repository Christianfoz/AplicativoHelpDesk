import 'package:helpdesk/model/Local.dart';
import 'package:helpdesk/util/Dio.dart';

class LocalRepository{

  /*

  ------------------------------------


  Métodos utilizando a biblioteca dio para comunicação com o back end


  -------------------------------------

  
  */

  // lista locais.
  
  Future<List<Local>> listarLocais() async{
    var _dio = CustomDio().instance;
    return await _dio.get("http://192.168.0.105:8080/local").then((value) {
        return value.data.map<Local>((b) => Local.fromMap(b)).toList()
          as List<Local>;
      } );
    }

    // lista locais por letra digitada

  Future<List<Local>> listarLocaisPorPalavra(String pesquisa) async{
    var _dio = CustomDio().instance;
    return await _dio.get("http://192.168.0.105:8080/local/busca/$pesquisa").then((value) {
        return value.data.map<Local>((b) => Local.fromMap(b)).toList()
          as List<Local>;
      } );
    }
  }


