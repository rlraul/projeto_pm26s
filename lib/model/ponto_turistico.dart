
import 'package:intl/intl.dart';

class PontoTutistico {

  static const NOME_TABELA = 'pontoTuristico';
  static const CAMPO_ID = 'id';
  static const CAMPO_NOME = 'nome';
  static const CAMPO_PAIS = 'pais';
  static const CAMPO_CIDADE = 'cidade';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_DATA_INC = 'data';

  int? id;
  String nome;
  String descricao;
  String cidade;
  String pais;
  DateTime? data_inclusao;

  PontoTutistico({
      required this.id,
      required this.nome,
      required this.cidade,
      required this.pais,
      required this.descricao,
      required this.data_inclusao,
  });

  String get retornarDataInclusaoFormatada {
    this.data_inclusao = DateTime.now();
    return DateFormat('dd/MM/yyyy').format(this.data_inclusao!);
  }

  Map<String, dynamic> toMap() => {
    CAMPO_ID: id,
    CAMPO_NOME: nome,
    CAMPO_DESCRICAO: descricao,
    CAMPO_CIDADE: cidade,
    CAMPO_PAIS: pais,
    CAMPO_DATA_INC:
    data_inclusao == null ? null : DateFormat("yyyy-MM-dd").format(data_inclusao!),
  };

  factory PontoTutistico.fromMap(Map<String, dynamic> map) => PontoTutistico(
    id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    nome: map[CAMPO_NOME] is String ? map[CAMPO_NOME] : '',
    descricao: map[CAMPO_DESCRICAO] is String ? map[CAMPO_DESCRICAO] : '',
    cidade: map[CAMPO_CIDADE] is String ? map[CAMPO_CIDADE] : '',
    pais: map[CAMPO_PAIS] is String ? map[CAMPO_PAIS] : '',
    data_inclusao: map[CAMPO_DATA_INC] is String
        ? DateFormat("yyyy-MM-dd").parse(map[CAMPO_DATA_INC])
        : null,
  );
}
