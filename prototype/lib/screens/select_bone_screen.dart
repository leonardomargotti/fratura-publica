import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../database/database_helper.dart';
import '../models/models.dart';

class SelectBoneScreen extends StatefulWidget {
  const SelectBoneScreen({Key? key}) : super(key: key);

  @override
  State<SelectBoneScreen> createState() => _SelectBoneScreenState();
}

class _SelectBoneScreenState extends State<SelectBoneScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _ossos = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadOssos();
  }
  
  Future<void> _loadOssos() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final ossos = await _databaseHelper.getOssos();
      setState(() {
        _ossos = ossos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar ossos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  void _selectBone(Map<String, dynamic> osso) {
    Navigator.pushNamed(
      context,
      '/fracture_parameters',
      arguments: {
        'osso': osso,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.selectBoneTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      AppConstants.selectBoneSubtitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Diagrama anatômico simplificado (placeholder)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Diagrama Anatômico',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    const Text(
                      'Ou selecione da lista:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 10),
                    
                    Expanded(
                      child: ListView.builder(
                        itemCount: _ossos.length,
                        itemBuilder: (context, index) {
                          final osso = _ossos[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(osso['nome']),
                              subtitle: Text(osso['regiao'] ?? ''),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () => _selectBone(osso),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
