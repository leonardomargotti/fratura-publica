import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import '../utils/offline_manager.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  
  final OfflineManager _offlineManager = OfflineManager();
  
  // Obter o banco de dados
  Future<Database> get database async {
    return await _offlineManager.database;
  }
  
  // Obter a lista de ossos
  Future<List<Map<String, dynamic>>> getOssos() async {
    final db = await database;
    return await db.query('Ossos', orderBy: 'nome');
  }
  
  // Obter a lista de sistemas de classificação
  Future<List<Map<String, dynamic>>> getSistemasClassificacao() async {
    final db = await database;
    return await db.query('SistemasClassificacao', orderBy: 'nome');
  }
  
  // Obter a lista de tipos de fratura
  Future<List<Map<String, dynamic>>> getTiposFratura() async {
    final db = await database;
    return await db.query('TiposFratura', orderBy: 'codigo');
  }
  
  // Obter tipos de fratura por osso
  Future<List<Map<String, dynamic>>> getTiposFraturaPorOsso(int ossoId) async {
    final db = await database;
    return await db.query(
      'TiposFratura',
      where: 'osso_id = ?',
      whereArgs: [ossoId],
      orderBy: 'codigo'
    );
  }
  
  // Obter tipos de fratura por sistema de classificação
  Future<List<Map<String, dynamic>>> getTiposFraturaPorSistema(int sistemaId) async {
    final db = await database;
    return await db.query(
      'TiposFratura',
      where: 'sistema_id = ?',
      whereArgs: [sistemaId],
      orderBy: 'codigo'
    );
  }
  
  // Obter imagens por tipo de fratura
  Future<List<Map<String, dynamic>>> getImagensPorTipoFratura(int tipoFraturaId) async {
    final db = await database;
    return await db.query(
      'Imagens',
      where: 'tipo_fratura_id = ?',
      whereArgs: [tipoFraturaId]
    );
  }
  
  // Obter tratamentos por tipo de fratura
  Future<List<Map<String, dynamic>>> getTratamentosPorTipoFratura(int tipoFraturaId) async {
    final db = await database;
    return await db.query(
      'Tratamentos',
      where: 'tipo_fratura_id = ?',
      whereArgs: [tipoFraturaId]
    );
  }
  
  // Obter condutas por tratamento
  Future<List<Map<String, dynamic>>> getCondutasPorTratamento(int tratamentoId) async {
    final db = await database;
    return await db.query(
      'Condutas',
      where: 'tratamento_id = ?',
      whereArgs: [tratamentoId],
      orderBy: 'ordem'
    );
  }
  
  // Obter parâmetros de classificação
  Future<List<Map<String, dynamic>>> getParametrosClassificacao() async {
    final db = await database;
    return await db.query('ParametrosClassificacao');
  }
  
  // Obter valores de parâmetros por parâmetro
  Future<List<Map<String, dynamic>>> getValoresParametrosPorParametro(int parametroId) async {
    final db = await database;
    return await db.query(
      'ValoresParametros',
      where: 'parametro_id = ?',
      whereArgs: [parametroId]
    );
  }
  
  // Classificar fratura com base nos parâmetros
  Future<List<Map<String, dynamic>>> classificarFratura(Map<String, dynamic> parametros) async {
    final db = await database;
    
    // Obter todos os tipos de fratura
    List<Map<String, dynamic>> tiposFratura = await getTiposFratura();
    
    // Lista para armazenar os resultados
    List<Map<String, dynamic>> resultados = [];
    
    // Para cada tipo de fratura, verificar se os parâmetros correspondem
    for (var tipoFratura in tiposFratura) {
      bool corresponde = true;
      
      // Obter as regras de classificação para este tipo de fratura
      List<Map<String, dynamic>> regras = await db.query(
        'RegrasClassificacao',
        where: 'tipo_fratura_id = ?',
        whereArgs: [tipoFratura['id']]
      );
      
      // Se não houver regras, pular este tipo de fratura
      if (regras.isEmpty) continue;
      
      // Verificar cada regra
      for (var regra in regras) {
        // Obter o parâmetro e o valor esperado
        final parametroId = regra['parametro_id'];
        final valorParametroId = regra['valor_parametro_id'];
        
        // Obter o nome do parâmetro
        final parametroMap = await db.query(
          'ParametrosClassificacao',
          where: 'id = ?',
          whereArgs: [parametroId]
        );
        
        if (parametroMap.isEmpty) {
          corresponde = false;
          break;
        }
        
        final nomeParametro = parametroMap.first['nome'].toString().toLowerCase().replaceAll(' ', '_');
        
        // Obter o valor esperado
        final valorParametroMap = await db.query(
          'ValoresParametros',
          where: 'id = ?',
          whereArgs: [valorParametroId]
        );
        
        if (valorParametroMap.isEmpty) {
          corresponde = false;
          break;
        }
        
        final valorEsperado = valorParametroMap.first['valor'];
        
        // Verificar se o parâmetro fornecido corresponde ao esperado
        if (!parametros.containsKey(nomeParametro) || parametros[nomeParametro] != valorEsperado) {
          corresponde = false;
          break;
        }
      }
      
      // Se todos os parâmetros corresponderem, adicionar aos resultados
      if (corresponde) {
        // Obter o sistema de classificação
        final sistemaMap = await db.query(
          'SistemasClassificacao',
          where: 'id = ?',
          whereArgs: [tipoFratura['sistema_id']]
        );
        
        final sistemaNome = sistemaMap.isNotEmpty ? sistemaMap.first['nome'] : 'Desconhecido';
        
        resultados.add({
          'id': tipoFratura['id'],
          'sistema_id': tipoFratura['sistema_id'],
          'sistema_nome': sistemaNome,
          'codigo': tipoFratura['codigo'],
          'nome': tipoFratura['nome'],
          'descricao': tipoFratura['descricao'],
          'caracteristicas': tipoFratura['caracteristicas'],
        });
      }
    }
    
    return resultados;
  }
  
  // Salvar classificação no histórico
  Future<int> saveClassificationHistory(
    Map<String, dynamic> parametros,
    List<Map<String, dynamic>> resultados, {
    String? notas,
  }) async {
    return await _offlineManager.saveClassificationHistory(
      parametros,
      resultados,
      notas: notas,
    );
  }
  
  // Obter histórico de classificações
  Future<List<Map<String, dynamic>>> getClassificationHistory() async {
    return await _offlineManager.getClassificationHistory();
  }
  
  // Atualizar status de sincronização
  Future<void> updateSyncStatus(String status) async {
    await _offlineManager.updateSyncStatus(status);
  }
  
  // Pesquisar no banco de dados
  Future<List<Map<String, dynamic>>> search(String query) async {
    final db = await database;
    
    // Pesquisar em tipos de fratura
    final tiposFratura = await db.query(
      'TiposFratura',
      where: 'nome LIKE ? OR codigo LIKE ? OR descricao LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%']
    );
    
    // Pesquisar em ossos
    final ossos = await db.query(
      'Ossos',
      where: 'nome LIKE ? OR descricao LIKE ?',
      whereArgs: ['%$query%', '%$query%']
    );
    
    // Pesquisar em sistemas de classificação
    final sistemas = await db.query(
      'SistemasClassificacao',
      where: 'nome LIKE ? OR descricao LIKE ?',
      whereArgs: ['%$query%', '%$query%']
    );
    
    // Combinar resultados
    List<Map<String, dynamic>> resultados = [];
    
    for (var tipo in tiposFratura) {
      resultados.add({
        'id': tipo['id'],
        'tipo': 'tipo_fratura',
        'nome': tipo['codigo'] + ' - ' + tipo['nome'],
        'descricao': tipo['descricao'],
      });
    }
    
    for (var osso in ossos) {
      resultados.add({
        'id': osso['id'],
        'tipo': 'osso',
        'nome': osso['nome'],
        'descricao': osso['descricao'],
      });
    }
    
    for (var sistema in sistemas) {
      resultados.add({
        'id': sistema['id'],
        'tipo': 'sistema',
        'nome': sistema['nome'],
        'descricao': sistema['descricao'],
      });
    }
    
    return resultados;
  }
}
