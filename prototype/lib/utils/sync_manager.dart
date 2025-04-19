import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../database/database_helper.dart';
import '../utils/connectivity_service.dart';

class SyncManager {
  // Singleton pattern
  static final SyncManager _instance = SyncManager._internal();
  factory SyncManager() => _instance;
  SyncManager._internal();
  
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final ConnectivityService _connectivityService = ConnectivityService();
  
  // Chaves para SharedPreferences
  static const String _lastSyncKey = 'last_sync_time';
  static const String _pendingSyncKey = 'pending_sync_operations';
  
  // Verificar se há operações pendentes de sincronização
  Future<bool> hasPendingSyncOperations() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingOperations = prefs.getStringList(_pendingSyncKey) ?? [];
    return pendingOperations.isNotEmpty;
  }
  
  // Adicionar uma operação à fila de sincronização
  Future<void> addSyncOperation(String operation, Map<String, dynamic> data) async {
    if (!_connectivityService.isOnline) {
      final prefs = await SharedPreferences.getInstance();
      final pendingOperations = prefs.getStringList(_pendingSyncKey) ?? [];
      
      final syncOperation = {
        'operation': operation,
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      pendingOperations.add(jsonEncode(syncOperation));
      await prefs.setStringList(_pendingSyncKey, pendingOperations);
    } else {
      // Se estiver online, executar a operação imediatamente
      await _executeSyncOperation(operation, data);
    }
  }
  
  // Executar uma operação de sincronização
  Future<bool> _executeSyncOperation(String operation, Map<String, dynamic> data) async {
    // Aqui seria implementada a lógica para sincronizar com o servidor
    // Por enquanto, apenas simulamos o sucesso da operação
    
    await Future.delayed(const Duration(seconds: 1)); // Simular tempo de rede
    
    // Atualizar o status de sincronização no banco de dados local
    await _databaseHelper.updateSyncStatus('sincronizado');
    
    return true;
  }
  
  // Sincronizar operações pendentes quando estiver online
  Future<bool> syncPendingOperations() async {
    if (!_connectivityService.isOnline) {
      return false;
    }
    
    final prefs = await SharedPreferences.getInstance();
    final pendingOperations = prefs.getStringList(_pendingSyncKey) ?? [];
    
    if (pendingOperations.isEmpty) {
      return true;
    }
    
    bool allSuccessful = true;
    List<String> remainingOperations = [];
    
    for (var operationJson in pendingOperations) {
      try {
        final operation = jsonDecode(operationJson);
        final success = await _executeSyncOperation(
          operation['operation'],
          operation['data'],
        );
        
        if (!success) {
          allSuccessful = false;
          remainingOperations.add(operationJson);
        }
      } catch (e) {
        allSuccessful = false;
        remainingOperations.add(operationJson);
      }
    }
    
    // Atualizar a lista de operações pendentes
    await prefs.setStringList(_pendingSyncKey, remainingOperations);
    
    // Atualizar a hora da última sincronização
    if (allSuccessful || remainingOperations.length < pendingOperations.length) {
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
    }
    
    return allSuccessful;
  }
  
  // Obter a hora da última sincronização
  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncString = prefs.getString(_lastSyncKey);
    
    if (lastSyncString != null) {
      return DateTime.parse(lastSyncString);
    }
    
    return null;
  }
  
  // Verificar se é necessário sincronizar (por exemplo, a cada 24 horas)
  Future<bool> needsSync() async {
    final lastSync = await getLastSyncTime();
    
    if (lastSync == null) {
      return true;
    }
    
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    
    // Sincronizar se a última sincronização foi há mais de 24 horas
    return difference.inHours > 24;
  }
  
  // Tentar sincronizar automaticamente
  Future<void> attemptAutoSync(BuildContext context) async {
    if (!_connectivityService.isOnline) {
      return;
    }
    
    final needSync = await needsSync();
    final hasPending = await hasPendingSyncOperations();
    
    if (needSync || hasPending) {
      final success = await syncPendingOperations();
      
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sincronização concluída com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Algumas operações não puderam ser sincronizadas'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
  
  // Adicionar uma classificação ao histórico e à fila de sincronização
  Future<void> addClassificationToHistory(
    Map<String, dynamic> parametros,
    List<Map<String, dynamic>> resultados,
    {String? notas}
  ) async {
    // Salvar localmente
    final id = await _databaseHelper.saveClassificationHistory(
      parametros,
      resultados,
      notas: notas,
    );
    
    // Adicionar à fila de sincronização
    await addSyncOperation('add_classification', {
      'id': id,
      'parametros': parametros,
      'resultados': resultados,
      'notas': notas,
      'data_hora': DateTime.now().toIso8601String(),
    });
  }
}
