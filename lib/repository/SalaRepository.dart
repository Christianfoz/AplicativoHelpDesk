import 'package:helpdesk/model/Sala.dart';
import 'package:helpdesk/util/Dio.dart';

class SalaRepository {


    Future<List<Sala>> listarSalasPorPiso(int id) async{
      var _dio = CustomDio().instance;
      return await _dio.get("http://192.168.0.107:8080/sala/buscarPorPiso/${id}")
      .then((value) {
        return value.data.map<Sala>((b) => Sala.fromMap(b)).toList()
          as List<Sala>;
      } );
    }
  }

