
import 'package:intl/intl.dart';

class PontoTutistico {

  static const NOME_TABELA      = 'pontoTuristico';
  static const CAMPO_ID         = 'id';
  static const CAMPO_NOME       = 'nome';
  static const CAMPO_DESCRICAO  = 'descricao';
  static const CAMPO_DATA_INC   = 'data';
  static const CAMPO_CEP        = 'cep';
  static const CAMPO_PAIS       = 'pais';
  static const CAMPO_UF         = 'uf';
  static const CAMPO_CIDADE     = 'cidade';
  static const CAMPO_BAIRRO     = 'bairro';
  static const CAMPO_LOGRADOURO = 'logradouro';

  int? id;
  String nome;
  String descricao;
  DateTime? data_inclusao;
  String cep;
  String pais;
  String uf;
  String cidade;
  String bairro;
  String logradouro;

  PontoTutistico({
      required this.id,
      required this.nome,
      required this.descricao,
      required this.data_inclusao,
      required this.cep,
      required this.pais,
      required this.uf,
      required this.cidade,
      required this.bairro,
      required this.logradouro,
  });

  String get retornarDataInclusaoFormatada {
    this.data_inclusao = DateTime.now();
    return DateFormat('dd/MM/yyyy').format(this.data_inclusao!);
  }

  Map<String, dynamic> toMap() => {
    CAMPO_ID: id,
    CAMPO_NOME: nome,
    CAMPO_DESCRICAO: descricao,
    CAMPO_DATA_INC:
      data_inclusao == null ? null : DateFormat("yyyy-MM-dd").format(data_inclusao!),
    CAMPO_CEP: cep,
    CAMPO_PAIS: pais,
    CAMPO_UF: uf,
    CAMPO_CIDADE: cidade,
    CAMPO_BAIRRO: bairro,
    CAMPO_LOGRADOURO: logradouro,
  };

  factory PontoTutistico.fromMap(Map<String, dynamic> map) => PontoTutistico(
    id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    nome: map[CAMPO_NOME] is String ? map[CAMPO_NOME] : '',
    descricao: map[CAMPO_DESCRICAO] is String ? map[CAMPO_DESCRICAO] : '',
    data_inclusao: map[CAMPO_DATA_INC] is String
        ? DateFormat("yyyy-MM-dd").parse(map[CAMPO_DATA_INC])
        : null,
    cep: map[CAMPO_CEP] is String ? map[CAMPO_CEP] : '',
    pais: map[CAMPO_PAIS] is String ? map[CAMPO_PAIS] : '',
    uf: map[CAMPO_UF] is String ? map[CAMPO_UF] : '',
    cidade: map[CAMPO_CIDADE] is String ? map[CAMPO_CIDADE] : '',
    bairro: map[CAMPO_BAIRRO] is String ? map[CAMPO_BAIRRO] : '',
    logradouro: map[CAMPO_LOGRADOURO] is String ? map[CAMPO_LOGRADOURO] : '',
  );
}
