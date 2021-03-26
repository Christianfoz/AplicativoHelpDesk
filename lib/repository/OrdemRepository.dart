import 'package:helpdesk/model/Bloco.dart';
import 'package:helpdesk/model/Ordem.dart';
import 'package:helpdesk/util/Dio.dart';

class OrdemRepository {
  
  Future<bool> criarOrdem(Ordem p) async{
      var _dio = CustomDio().instance;
      return await _dio.post("http://192.168.0.107:8080/ordem/",data: p.toJson())
      .then((value) => null);
    }

  }

