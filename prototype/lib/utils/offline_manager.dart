import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:typed_data';

class OfflineManager {
  // Singleton pattern
  static final OfflineManager _instance = OfflineManager._internal();
  factory OfflineManager() => _instance;
  OfflineManager._internal();
  
  static Database? _database;
  
  // Getter para o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  // Inicializar o banco de dados
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'fracture_classifier.db');
    
    // Abrir o banco de dados
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }
  
  // Verificar se o banco de dados está inicializado
  Future<bool> isDatabaseInitialized() async {
    try {
      final db = await database;
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Criar as tabelas do banco de dados
  Future<void> _createDatabase(Database db, int version) async {
    // Tabela de Ossos
    await db.execute('''
      CREATE TABLE Ossos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        regiao TEXT,
        descricao TEXT
      )
    ''');
    
    // Tabela de Sistemas de Classificação
    await db.execute('''
      CREATE TABLE SistemasClassificacao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        descricao TEXT,
        referencia TEXT
      )
    ''');
    
    // Tabela de Tipos de Fratura
    await db.execute('''
      CREATE TABLE TiposFratura (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        osso_id INTEGER,
        sistema_id INTEGER NOT NULL,
        codigo TEXT NOT NULL,
        nome TEXT NOT NULL,
        descricao TEXT,
        caracteristicas TEXT,
        FOREIGN KEY (osso_id) REFERENCES Ossos (id),
        FOREIGN KEY (sistema_id) REFERENCES SistemasClassificacao (id)
      )
    ''');
    
    // Tabela de Imagens
    await db.execute('''
      CREATE TABLE Imagens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo_fratura_id INTEGER NOT NULL,
        nome_arquivo TEXT NOT NULL,
        dados BLOB,
        descricao TEXT,
        tipo_imagem TEXT,
        FOREIGN KEY (tipo_fratura_id) REFERENCES TiposFratura (id)
      )
    ''');
    
    // Tabela de Tratamentos
    await db.execute('''
      CREATE TABLE Tratamentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo_fratura_id INTEGER NOT NULL,
        nome TEXT NOT NULL,
        descricao TEXT,
        indicacoes TEXT,
        contraindicacoes TEXT,
        FOREIGN KEY (tipo_fratura_id) REFERENCES TiposFratura (id)
      )
    ''');
    
    // Tabela de Condutas
    await db.execute('''
      CREATE TABLE Condutas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tratamento_id INTEGER NOT NULL,
        descricao TEXT NOT NULL,
        ordem INTEGER,
        FOREIGN KEY (tratamento_id) REFERENCES Tratamentos (id)
      )
    ''');
    
    // Tabela de Parâmetros de Classificação
    await db.execute('''
      CREATE TABLE ParametrosClassificacao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        descricao TEXT
      )
    ''');
    
    // Tabela de Valores de Parâmetros
    await db.execute('''
      CREATE TABLE ValoresParametros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parametro_id INTEGER NOT NULL,
        valor TEXT NOT NULL,
        descricao TEXT,
        FOREIGN KEY (parametro_id) REFERENCES ParametrosClassificacao (id)
      )
    ''');
    
    // Tabela de Regras de Classificação
    await db.execute('''
      CREATE TABLE RegrasClassificacao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo_fratura_id INTEGER NOT NULL,
        parametro_id INTEGER NOT NULL,
        valor_parametro_id INTEGER NOT NULL,
        FOREIGN KEY (tipo_fratura_id) REFERENCES TiposFratura (id),
        FOREIGN KEY (parametro_id) REFERENCES ParametrosClassificacao (id),
        FOREIGN KEY (valor_parametro_id) REFERENCES ValoresParametros (id)
      )
    ''');
    
    // Tabela de Histórico de Classificações
    await db.execute('''
      CREATE TABLE HistoricoClassificacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data_hora TEXT NOT NULL,
        parametros TEXT NOT NULL,
        resultados TEXT NOT NULL,
        notas TEXT,
        sincronizado INTEGER DEFAULT 0
      )
    ''');
    
    // Tabela de Informações de Sincronização
    await db.execute('''
      CREATE TABLE SincronizacaoInfo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ultima_sincronizacao TEXT,
        status TEXT
      )
    ''');
    
    // Inserir dados iniciais
    await _insertInitialData(db);
  }
  
  // Inserir dados iniciais no banco de dados
  Future<void> _insertInitialData(Database db) async {
    // Inserir ossos
    await db.insert('Ossos', {'nome': 'Úmero', 'regiao': 'Membro Superior'});
    await db.insert('Ossos', {'nome': 'Rádio', 'regiao': 'Membro Superior'});
    await db.insert('Ossos', {'nome': 'Ulna', 'regiao': 'Membro Superior'});
    await db.insert('Ossos', {'nome': 'Fêmur', 'regiao': 'Membro Inferior'});
    await db.insert('Ossos', {'nome': 'Tíbia', 'regiao': 'Membro Inferior'});
    await db.insert('Ossos', {'nome': 'Fíbula', 'regiao': 'Membro Inferior'});
    
    // Inserir sistemas de classificação
    await db.insert('SistemasClassificacao', {
      'nome': 'AO/OTA',
      'descricao': 'Sistema de classificação desenvolvido pela AO Foundation e Orthopaedic Trauma Association',
      'referencia': 'https://www.aofoundation.org/trauma/clinical-library-and-tools/journals-and-publications/classification'
    });
    
    await db.insert('SistemasClassificacao', {
      'nome': 'Salter-Harris',
      'descricao': 'Sistema de classificação para fraturas fisárias em crianças',
      'referencia': 'https://radiopaedia.org/articles/salter-harris-classification'
    });
    
    await db.insert('SistemasClassificacao', {
      'nome': 'Neer',
      'descricao': 'Sistema de classificação para fraturas do úmero proximal',
      'referencia': 'https://ortopediaonline.med.br/classificacao-de-neer/'
    });
    
    await db.insert('SistemasClassificacao', {
      'nome': 'Weber',
      'descricao': 'Sistema de classificação para fraturas do tornozelo',
      'referencia': 'https://ortopediaonline.med.br/classificacao-de-danis-weber/'
    });
    
    await db.insert('SistemasClassificacao', {
      'nome': 'Garden',
      'descricao': 'Sistema de classificação para fraturas do colo do fêmur',
      'referencia': 'https://ortopediaonline.med.br/classificacao-de-garden/'
    });
    
    await db.insert('SistemasClassificacao', {
      'nome': 'Schatzker',
      'descricao': 'Sistema de classificação para fraturas do platô tibial',
      'referencia': 'https://radiopaedia.org/articles/schatzker-classification-of-tibial-plateau-fractures-1'
    });
    
    // Inserir parâmetros de classificação
    final regiaoId = await db.insert('ParametrosClassificacao', {
      'nome': 'Região do Osso',
      'descricao': 'Região do osso afetada pela fratura'
    });
    
    final tipoTracoId = await db.insert('ParametrosClassificacao', {
      'nome': 'Tipo de Traço',
      'descricao': 'Padrão do traço de fratura'
    });
    
    final exposicaoId = await db.insert('ParametrosClassificacao', {
      'nome': 'Exposição',
      'descricao': 'Se a fratura é exposta ou fechada'
    });
    
    final idadePacienteId = await db.insert('ParametrosClassificacao', {
      'nome': 'Idade do Paciente',
      'descricao': 'Se o paciente é adulto ou criança'
    });
    
    final deslocamentoId = await db.insert('ParametrosClassificacao', {
      'nome': 'Deslocamento',
      'descricao': 'Grau de deslocamento dos fragmentos'
    });
    
    final cominuicaoId = await db.insert('ParametrosClassificacao', {
      'nome': 'Cominuição',
      'descricao': 'Se a fratura é cominutiva'
    });
    
    final articularId = await db.insert('ParametrosClassificacao', {
      'nome': 'Articular',
      'descricao': 'Se a fratura envolve a superfície articular'
    });
    
    // Inserir valores de parâmetros
    // Região do Osso
    await db.insert('ValoresParametros', {'parametro_id': regiaoId, 'valor': 'proximal'});
    await db.insert('ValoresParametros', {'parametro_id': regiaoId, 'valor': 'diafisaria'});
    await db.insert('ValoresParametros', {'parametro_id': regiaoId, 'valor': 'distal'});
    
    // Tipo de Traço
    await db.insert('ValoresParametros', {'parametro_id': tipoTracoId, 'valor': 'transverso'});
    await db.insert('ValoresParametros', {'parametro_id': tipoTracoId, 'valor': 'obliquo'});
    await db.insert('ValoresParametros', {'parametro_id': tipoTracoId, 'valor': 'espiral'});
    await db.insert('ValoresParametros', {'parametro_id': tipoTracoId, 'valor': 'cominutivo'});
    await db.insert('ValoresParametros', {'parametro_id': tipoTracoId, 'valor': 'segmentar'});
    
    // Exposição
    await db.insert('ValoresParametros', {'parametro_id': exposicaoId, 'valor': 'fechada'});
    await db.insert('ValoresParametros', {'parametro_id': exposicaoId, 'valor': 'exposta'});
    
    // Idade do Paciente
    await db.insert('ValoresParametros', {'parametro_id': idadePacienteId, 'valor': 'adulto'});
    await db.insert('ValoresParametros', {'parametro_id': idadePacienteId, 'valor': 'crianca'});
    
    // Deslocamento
    await db.insert('ValoresParametros', {'parametro_id': deslocamentoId, 'valor': 'sem_deslocamento'});
    await db.insert('ValoresParametros', {'parametro_id': deslocamentoId, 'valor': 'deslocamento_parcial'});
    await db.insert('ValoresParametros', {'parametro_id': deslocamentoId, 'valor': 'deslocamento_completo'});
    
    // Cominuição
    await db.insert('ValoresParametros', {'parametro_id': cominuicaoId, 'valor': 'sim'});
    await db.insert('ValoresParametros', {'parametro_id': cominuicaoId, 'valor': 'nao'});
    
    // Articular
    await db.insert('ValoresParametros', {'parametro_id': articularId, 'valor': 'sim'});
    await db.insert('ValoresParametros', {'parametro_id': articularId, 'valor': 'nao'});
  }
  
  // Salvar uma imagem no banco de dados
  Future<int> saveImage(
    int tipoFraturaId,
    String nomeArquivo,
    Uint8List dados, {
    String? descricao,
    String? tipoImagem,
  }) async {
    final db = await database;
    
    return await db.insert('Imagens', {
      'tipo_fratura_id': tipoFraturaId,
      'nome_arquivo': nomeArquivo,
      'dados': dados,
      'descricao': descricao,
      'tipo_imagem': tipoImagem,
    });
  }
  
  // Obter uma imagem do banco de dados
  Future<Map<String, dynamic>?> getImage(int id) async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'Imagens',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return maps.first;
    }
    
    return null;
  }
  
  // Salvar uma classificação no histórico
  Future<int> saveClassificationHistory(
    Map<String, dynamic> parametros,
    List<Map<String, dynamic>> resultados, {
    String? notas,
  }) async {
    final db = await database;
    
    return await db.insert('HistoricoClassificacoes', {
      'data_hora': DateTime.now().toIso8601String(),
      'parametros': parametros.toString(),
      'resultados': resultados.toString(),
      'notas': notas,
      'sincronizado': 0,
    });
  }
  
  // Obter o histórico de classificações
  Future<List<Map<String, dynamic>>> getClassificationHistory() async {
    final db = await database;
    
    return await db.query(
      'HistoricoClassificacoes',
      orderBy: 'data_hora DESC',
    );
  }
  
  // Atualizar o status de sincronização
  Future<void> updateSyncStatus(String status) async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query('SincronizacaoInfo');
    
    if (maps.isEmpty) {
      await db.insert('SincronizacaoInfo', {
        'ultima_sincronizacao': DateTime.now().toIso8601String(),
        'status': status,
      });
    } else {
      await db.update(
        'SincronizacaoInfo',
        {
          'ultima_sincronizacao': DateTime.now().toIso8601String(),
          'status': status,
        },
        where: 'id = ?',
        whereArgs: [maps.first['id']],
      );
    }
  }
}
