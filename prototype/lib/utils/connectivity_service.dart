import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  // Singleton pattern
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();
  
  // Variáveis para controle de conectividade
  bool _isOnline = false;
  final Connectivity _connectivity = Connectivity();
  
  // Getter para verificar se está online
  bool get isOnline => _isOnline;
  
  // Inicializar o serviço de conectividade
  Future<void> initialize() async {
    // Verificar o estado inicial de conectividade
    final connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
    
    // Configurar listener para mudanças de conectividade
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  
  // Atualizar o status de conectividade
  void _updateConnectionStatus(ConnectivityResult result) {
    _isOnline = result != ConnectivityResult.none;
  }
  
  // Liberar recursos
  void dispose() {
    // Nada a fazer aqui, pois o Connectivity Plus gerencia seus próprios recursos
  }
  
  // Widget para exibir banner de conectividade
  static Widget connectivityBanner(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context);
    
    if (!connectivityService.isOnline) {
      return Container(
        width: double.infinity,
        color: Colors.orange,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: const Text(
          'Você está offline. Algumas funcionalidades podem estar limitadas.',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
}
