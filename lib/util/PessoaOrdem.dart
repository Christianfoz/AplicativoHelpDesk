/*

-----------------------------------------------------------

Classe que contem um pessoa e um chamado.
Enviado como argumento para uma tela de detalhe de chamado
------------------------------------------------------------

*/


import 'package:helpdesk/model/Ordem.dart';
import 'package:helpdesk/model/Pessoa.dart';

class PessoaOrdem {
  Pessoa pessoa;
  Ordem ordem;
  PessoaOrdem({
    this.pessoa,
    this.ordem,
  });
}
