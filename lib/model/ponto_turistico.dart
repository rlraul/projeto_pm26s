
import 'package:intl/intl.dart';

class PontoTutistico {

  static const CAMPO_ID = 'id';
  static const CAMPO_NOME = 'nome';
  static const CAMPO_PAIS = 'pais';
  static const CAMPO_CIDADE = 'cidade';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_DATA_INC = 'data';

  int id;
  String nome;
  String descricao;
  DateTime? data_inclusao;

  PontoTutistico({
      required this.id,
      required this.nome,
      required this.descricao,
      required this.data_inclusao
  });

  String get retornarDataInclusaoFormatada {
    if (this.data_inclusao == null) {
      return "";
    }
    return DateFormat('dd/MM/yyyy').format(this.data_inclusao!);
  }
}
