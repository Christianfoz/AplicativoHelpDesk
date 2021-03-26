import 'package:helpdesk/model/Bloco.dart';
import 'package:helpdesk/util/Dio.dart';

class BlocoRepository {


    Future<List<Bloco>> listarBlocos() async{
      var _dio = CustomDio().instance;
      return await _dio.get("http://192.168.0.107:8080/bloco/")
      .then((value) {
        return value.data.map<Bloco>((b) => Bloco.fromMap(b)).toList()
          as List<Bloco>;
      } );
    }
  }

