import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../database/database_helper.dart';
import '../models/models.dart';

class FractureParametersScreen extends StatefulWidget {
  const FractureParametersScreen({Key? key}) : super(key: key);

  @override
  State<FractureParametersScreen> createState() => _FractureParametersScreenState();
}

class _FractureParametersScreenState extends State<FractureParametersScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  
  // Parâmetros selecionados
  Map<String, dynamic> _parametros = {};
  
  // Osso selecionado
  Map<String, dynamic>? _osso;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Obter o osso selecionado dos argumentos da rota
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('osso')) {
      _osso = args['osso'] as Map<String, dynamic>;
      
      // Inicializar parâmetros com o osso selecionado
      _parametros['osso_id'] = _osso!['id'];
    }
  }
  
  void _updateParametro(String parametro, String valor) {
    setState(() {
      _parametros[parametro] = valor;
    });
  }
  
  void _classificarFratura() async {
    if (_parametros.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha pelo menos 3 parâmetros para classificar a fratura.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    try {
      final resultados = await _databaseHelper.classificarFratura(_parametros);
      
      if (resultados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nenhuma classificação encontrada para os parâmetros informados.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      // Navegar para a tela de resultados
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/classification_results',
          arguments: {
            'osso': _osso,
            'parametros': _parametros,
            'resultados': resultados,
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao classificar fratura: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.fractureParametersTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Osso selecionado
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Osso Selecionado:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _osso?['nome'] ?? 'Nenhum osso selecionado',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      if (_osso?['regiao'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Região: ${_osso!['regiao']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Parâmetros da fratura
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Região do osso
                      _buildParameterSection(
                        AppConstants.boneRegionLabel,
                        [
                          AppConstants.proximalRegion,
                          AppConstants.diaphysealRegion,
                          AppConstants.distalRegion,
                        ],
                        'regiao',
                      ),
                      
                      // Tipo de traço
                      _buildParameterSection(
                        AppConstants.fractureTypeLabel,
                        [
                          AppConstants.transverseFracture,
                          AppConstants.obliqueFracture,
                          AppConstants.spiralFracture,
                          AppConstants.comminutedFracture,
                          AppConstants.segmentalFracture,
                        ],
                        'tipo_traco',
                      ),
                      
                      // Exposição
                      _buildParameterSection(
                        AppConstants.exposureLabel,
                        [
                          AppConstants.closedFracture,
                          AppConstants.openFracture,
                        ],
                        'exposicao',
                      ),
                      
                      // Idade do paciente
                      _buildParameterSection(
                        AppConstants.patientAgeLabel,
                        [
                          AppConstants.adultPatient,
                          AppConstants.childPatient,
                        ],
                        'idade_paciente',
                      ),
                      
                      // Deslocamento
                      _buildParameterSection(
                        AppConstants.displacementLabel,
                        [
                          AppConstants.noDisplacement,
                          AppConstants.partialDisplacement,
                          AppConstants.completeDisplacement,
                        ],
                        'deslocamento',
                      ),
                      
                      // Cominuição
                      _buildParameterSection(
                        AppConstants.comminutionLabel,
                        [
                          AppConstants.yes,
                          AppConstants.no,
                        ],
                        'cominuicao',
                      ),
                      
                      // Articular
                      _buildParameterSection(
                        AppConstants.articularLabel,
                        [
                          AppConstants.yes,
                          AppConstants.no,
                        ],
                        'articular',
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Botão para classificar
              ElevatedButton(
                onPressed: _classificarFratura,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  AppConstants.classifyButton,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildParameterSection(String title, List<String> options, String parametro) {
    final selectedValue = _parametros[parametro];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: options.map((option) {
                final value = option.toLowerCase().replaceAll(' ', '_');
                final isSelected = selectedValue == value;
                
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      _updateParametro(parametro, value);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
