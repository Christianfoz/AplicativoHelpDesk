import 'package:helpdesk/model/Piso.dart';
import 'package:helpdesk/util/Dio.dart';

class PisoRepository {


    Future<List<Piso>> listarPisosPorBloco(int id) async{
      var _dio = CustomDio().instance;
      return await _dio.get("http://192.168.0.107:8080/piso/buscarPorBloco/$id")
      .then((value) {
        return value.data.map<Piso>((b) => Piso.fromMap(b)).toList()
          as List<Piso>;
      } );
    }
  }

