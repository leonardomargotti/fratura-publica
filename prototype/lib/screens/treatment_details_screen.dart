import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../database/database_helper.dart';
import '../models/models.dart';

class TreatmentDetailsScreen extends StatefulWidget {
  const TreatmentDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentDetailsScreen> createState() => _TreatmentDetailsScreenState();
}

class _TreatmentDetailsScreenState extends State<TreatmentDetailsScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  
  List<Map<String, dynamic>> _condutas = [];
  bool _isLoading = true;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCondutas();
  }
  
  Future<void> _loadCondutas() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Obter os argumentos da rota
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      final tratamento = args['tratamento'] as Map<String, dynamic>;
      final tratamentoId = tratamento['id'] as int;
      
      // Carregar condutas
      final condutas = await _databaseHelper.getCondutasPorTratamento(tratamentoId);
      
      setState(() {
        _condutas = condutas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar condutas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obter os argumentos da rota
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do Tratamento'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Nenhum detalhe disponível'),
        ),
      );
    }
    
    final tratamento = args['tratamento'] as Map<String, dynamic>;
    final resultado = args['resultado'] as Map<String, dynamic>?;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Tratamento: ${tratamento['nome']}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Título
                    Text(
                      tratamento['nome'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Fratura relacionada
                    if (resultado != null)
                      Text(
                        'Para: ${resultado['codigo']} - ${resultado['nome']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Descrição
                    if (tratamento['descricao'] != null)
                      _buildSection(
                        'Descrição',
                        tratamento['descricao'],
                      ),
                    
                    // Indicações
                    if (tratamento['indicacoes'] != null)
                      _buildSection(
                        AppConstants.indicationsLabel,
                        tratamento['indicacoes'],
                      ),
                    
                    // Contraindicações
                    if (tratamento['contraindicacoes'] != null)
                      _buildSection(
                        AppConstants.contraindicationsLabel,
                        tratamento['contraindicacoes'],
                      ),
                    
                    // Procedimentos
                    _buildProcedurasSection(),
                    
                    // Possíveis complicações
                    _buildSection(
                      AppConstants.possibleComplicationsLabel,
                      'Infecção, lesão neurovascular, falha do implante, consolidação viciosa, pseudoartrose.',
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Botão para compartilhar
                    ElevatedButton.icon(
                      onPressed: () {
                        // Compartilhar tratamento
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Função de compartilhamento não implementada neste protótipo'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Compartilhar Tratamento'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
  
  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProcedurasSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            AppConstants.proceduresLabel,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_condutas.isEmpty)
            const Text(
              'Nenhum procedimento disponível',
              style: TextStyle(
                fontSize: 16,
              ),
            )
          else
            Column(
              children: _condutas.map((conduta) {
                final ordem = conduta['ordem'] != null ? '${conduta['ordem']}. ' : '';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (conduta['ordem'] != null)
                        Text(
                          '$ordem',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          conduta['descricao'],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
