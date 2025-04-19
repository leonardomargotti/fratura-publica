import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../database/database_helper.dart';
import '../models/models.dart';

class ClassificationDetailsScreen extends StatefulWidget {
  const ClassificationDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ClassificationDetailsScreen> createState() => _ClassificationDetailsScreenState();
}

class _ClassificationDetailsScreenState extends State<ClassificationDetailsScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  
  List<Map<String, dynamic>> _imagens = [];
  List<Map<String, dynamic>> _tratamentos = [];
  bool _isLoading = true;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }
  
  Future<void> _loadData() async {
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
      
      final resultado = args['resultado'] as Map<String, dynamic>;
      final tipoFraturaId = resultado['id'] as int;
      
      // Carregar imagens
      final imagens = await _databaseHelper.getImagensPorTipoFratura(tipoFraturaId);
      
      // Carregar tratamentos
      final tratamentos = await _databaseHelper.getTratamentosPorTipoFratura(tipoFraturaId);
      
      setState(() {
        _imagens = imagens;
        _tratamentos = tratamentos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar detalhes: $e'),
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
          title: const Text(AppConstants.detailsTitle),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Nenhum detalhe disponível'),
        ),
      );
    }
    
    final resultado = args['resultado'] as Map<String, dynamic>;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${resultado['codigo']}'),
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
                      resultado['nome'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Sistema de classificação
                    Text(
                      'Sistema: ${resultado['sistema_nome']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Imagem principal (placeholder)
                    if (_imagens.isNotEmpty)
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Imagem da Fratura',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Nenhuma imagem disponível',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Descrição
                    _buildSection(
                      AppConstants.descriptionLabel,
                      resultado['descricao'] ?? 'Nenhuma descrição disponível',
                    ),
                    
                    // Características radiográficas
                    _buildSection(
                      AppConstants.radiographicFeaturesLabel,
                      resultado['caracteristicas'] ?? 'Nenhuma característica disponível',
                    ),
                    
                    // Tratamentos sugeridos
                    _buildTratamentosSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Botões de ação
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _imagens.isNotEmpty
                                ? () {
                                    // Navegar para galeria de imagens
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(AppConstants.viewMoreImagesButton),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _tratamentos.isNotEmpty
                                ? () {
                                    Navigator.pushNamed(
                                      context,
                                      '/treatment_details',
                                      arguments: {
                                        'tratamento': _tratamentos.first,
                                        'resultado': resultado,
                                      },
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Colors.green,
                            ),
                            child: const Text(AppConstants.viewTreatmentDetailsButton),
                          ),
                        ),
                      ],
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
  
  Widget _buildTratamentosSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            AppConstants.suggestedTreatmentsLabel,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_tratamentos.isEmpty)
            const Text(
              'Nenhum tratamento disponível',
              style: TextStyle(
                fontSize: 16,
              ),
            )
          else
            Column(
              children: _tratamentos.map((tratamento) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(tratamento['nome']),
                    subtitle: tratamento['descricao'] != null
                        ? Text(
                            tratamento['descricao'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/treatment_details',
                        arguments: {
                          'tratamento': tratamento,
                          'resultado': args?['resultado'],
                        },
                      );
                    },
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
