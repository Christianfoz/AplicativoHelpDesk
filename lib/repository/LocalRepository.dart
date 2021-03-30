import 'package:helpdesk/model/Local.dart';
import 'package:helpdesk/util/Dio.dart';

class LocalRepository{
  
  Future<List<Local>> listarLocais() async{
    var _dio = CustomDio().instance;
    return await _dio.get("http://192.168.0.107:8080/local").then((value) {
        return value.data.map<Local>((b) => Local.fromMap(b)).toList()
          as List<Local>;
      } );
    }

  Future<List<Local>> listarLocaisPorPalavra(String pesquisa) async{
    var _dio = CustomDio().instance;
    return await _dio.get("http://192.168.0.107:8080/local/busca/$pesquisa").then((value) {
        return value.data.map<Local>((b) => Local.fromMap(b)).toList()
          as List<Local>;
      } );
    }
  }


