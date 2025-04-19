import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../database/database_helper.dart';

class DatabaseQueryScreen extends StatefulWidget {
  const DatabaseQueryScreen({Key? key}) : super(key: key);

  @override
  State<DatabaseQueryScreen> createState() => _DatabaseQueryScreenState();
}

class _DatabaseQueryScreenState extends State<DatabaseQueryScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  
  List<Map<String, dynamic>> _resultados = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _search() async {
    final query = _searchController.text.trim();
    
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um termo para pesquisar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });
    
    try {
      final resultados = await _databaseHelper.search(query);
      
      setState(() {
        _resultados = resultados;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao pesquisar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.databaseQueryTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo de pesquisa
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: AppConstants.searchLabel,
                  hintText: AppConstants.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onSubmitted: (_) => _search(),
              ),
              
              const SizedBox(height: 16),
              
              // Botão de pesquisa
              ElevatedButton(
                onPressed: _search,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  AppConstants.searchButton,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Resultados da pesquisa
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _hasSearched
                        ? _resultados.isEmpty
                            ? const Center(
                                child: Text(
                                  AppConstants.noResultsFound,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: _resultados.length,
                                itemBuilder: (context, index) {
                                  final resultado = _resultados[index];
                                  
                                  IconData icon;
                                  Color color;
                                  
                                  switch (resultado['tipo']) {
                                    case 'tipo_fratura':
                                      icon = Icons.healing;
                                      color = Colors.red;
                                      break;
                                    case 'osso':
                                      icon = Icons.accessibility_new;
                                      color = Colors.blue;
                                      break;
                                    case 'sistema':
                                      icon = Icons.category;
                                      color = Colors.green;
                                      break;
                                    default:
                                      icon = Icons.info;
                                      color = Colors.grey;
                                  }
                                  
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: color,
                                        child: Icon(
                                          icon,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(resultado['nome']),
                                      subtitle: resultado['descricao'] != null
                                          ? Text(
                                              resultado['descricao'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          : null,
                                      trailing: const Icon(Icons.arrow_forward_ios),
                                      onTap: () {
                                        // Navegar para detalhes do resultado
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Detalhes não implementados neste protótipo'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              )
                        : const Center(
                            child: Text(
                              AppConstants.searchInstructions,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
