/*

-----------------------------------------------------------

Classe que contem uma pessoa logada e uma pessoa no qual eu quero ver o perfil
Esta classe é enviada para a tela de perfil como argumento

------------------------------------------------------------

*/


import 'package:helpdesk/model/Pessoa.dart';

class PerfilUtil{
  Pessoa pessoaLogada;
  Pessoa pessoaPerfil;
  
  PerfilUtil({this.pessoaLogada, this.pessoaPerfil});
}