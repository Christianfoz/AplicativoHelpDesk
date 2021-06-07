/*

-----------------------------------------------------------

Classe que contem um pessoa filtro. Contém pessoa e um valor inteiro como filtro.
Este número signifca qual tipo de situacao eu quero filtrar na tela

------------------------------------------------------------

*/


import 'package:helpdesk/model/Pessoa.dart';

class PessoaFiltro {
  Pessoa pessoa;
  int filtro;
  PessoaFiltro({
    this.pessoa,
    this.filtro,
  });

  

  
}
