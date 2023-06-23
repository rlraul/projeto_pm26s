import 'package:projeto/database/provider.dart';
import 'package:projeto/model/ponto_turistico.dart';

class PontoTuristicoDao{

  final dbProvider = Provider.instance;

  Future<bool> salvar(PontoTutistico pontoTutistico) async {
    final database = await dbProvider.database;
    final valores = pontoTutistico.toMap();
    if (pontoTutistico.id == null) {
      pontoTutistico.id = await database.insert(PontoTutistico.NOME_TABELA, valores);
      return true;
    } else {
      final registrosAtualizados = await database.update(
        PontoTutistico.NOME_TABELA,
        valores,
        where: '${PontoTutistico.CAMPO_ID} = ?',
        whereArgs: [pontoTutistico.id],
      );
      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover(int id) async {
    final database = await dbProvider.database;
    final registrosAtualizados = await database.delete(
      PontoTutistico.NOME_TABELA,
      where: '${PontoTutistico.CAMPO_ID} = ?',
      whereArgs: [id],
    );
    return registrosAtualizados > 0;
  }

  Future<List<PontoTutistico>> listar(
      {String filtro = '',
        String campoOrdenacao = PontoTutistico.CAMPO_ID,
        bool usarOrdemDecrescente = false
      }) async {
    String? where;
    if(filtro.isNotEmpty){
      where = "UPPER(${PontoTutistico.CAMPO_DESCRICAO}) LIKE '${filtro.toUpperCase()}%'";
    }
    var orderBy = campoOrdenacao;

    if(usarOrdemDecrescente){
      orderBy += ' DESC';
    }
    final database = await dbProvider.database;
    final resultado = await database.query(PontoTutistico.NOME_TABELA,
      columns:
        [PontoTutistico.CAMPO_ID,
         PontoTutistico.CAMPO_NOME,
         PontoTutistico.CAMPO_DESCRICAO,
         PontoTutistico.CAMPO_CEP,
         PontoTutistico.CAMPO_UF,
         PontoTutistico.CAMPO_BAIRRO,
         PontoTutistico.CAMPO_LOGRADOURO,
         PontoTutistico.CAMPO_CIDADE,
         PontoTutistico.CAMPO_PAIS,
         PontoTutistico.CAMPO_DATA_INC],
      where: where,
      orderBy: orderBy,
    );
    return resultado.map((m) => PontoTutistico.fromMap(m)).toList();
  }

}