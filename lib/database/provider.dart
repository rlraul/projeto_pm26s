
import 'package:projeto/model/ponto_turistico.dart';
import 'package:sqflite/sqflite.dart';

class Provider {
  static const _dbName = 'pontos-turisticos.db';
  static const _dbVersion = 2;

  Provider._init();
  static final Provider instance = Provider._init();

  Database? _database;

  Future<Database> get database async => _database ??=await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = '$databasesPath/$_dbName';

    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        '''
          CREATE TABLE pontoTuristico (
            ${PontoTutistico.CAMPO_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${PontoTutistico.CAMPO_NOME} TEXT NOT NULL,
            ${PontoTutistico.CAMPO_DESCRICAO} TEXT,
            ${PontoTutistico.CAMPO_CIDADE} TEXT NOT NULL,
            ${PontoTutistico.CAMPO_PAIS} TEXT NOT NULL,
            ${PontoTutistico.CAMPO_DATA_INC} TEXT NOT NULL
          );  
        '''
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch(oldVersion){
      case 1:
        {
            await db.execute('''
            ALTER TABLE ${PontoTutistico.NOME_TABELA}
            ADD ${PontoTutistico.CAMPO_CEP} TEXT NOT NULL DEFAULT '';
            ''');

            await db.execute('''
            ALTER TABLE ${PontoTutistico.NOME_TABELA}
            ADD ${PontoTutistico.CAMPO_UF} TEXT NOT NULL DEFAULT '';
            ''');

            await db.execute('''
            ALTER TABLE ${PontoTutistico.NOME_TABELA}
            ADD ${PontoTutistico.CAMPO_BAIRRO} TEXT NOT NULL DEFAULT '';
            ''');

            await db.execute('''
            ALTER TABLE ${PontoTutistico.NOME_TABELA}
            ADD ${PontoTutistico.CAMPO_LOGRADOURO} TEXT NOT NULL DEFAULT '';
            ''');
        }
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}