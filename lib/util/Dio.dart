/*


-----------------------------------------------------------

Dio é uma biblioteca para facilitar para fazer requisições HTTP

-----------------------------------------------------------

*/


import 'package:dio/dio.dart';

class CustomDio{
    var _dio;

  CustomDio(){
    _dio = Dio();
  }

  Dio get instance => _dio;
}