import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../models/models.dart';

class ClassificationResultsScreen extends StatelessWidget {
  const ClassificationResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obter os argumentos da rota
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.resultsTitle),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Nenhum resultado disponível'),
        ),
      );
    }
    
    final osso = args['osso'] as Map<String, dynamic>?;
    final parametros = args['parametros'] as Map<String, dynamic>;
    final resultados = args['resultados'] as List<Map<String, dynamic>>;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.resultsTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Osso e parâmetros
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Osso: ${osso?['nome'] ?? 'Não especificado'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Parâmetros:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...parametros.entries.map((entry) {
                        final key = entry.key.replaceAll('_', ' ');
                        final value = entry.value.toString().replaceAll('_', ' ');
                        return Text('$key: $value');
                      }).toList(),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Título dos resultados
              const Text(
                AppConstants.applicableClassifications,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Lista de resultados
              Expanded(
                child: ListView.builder(
                  itemCount: resultados.length,
                  itemBuilder: (context, index) {
                    final resultado = resultados[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          '${resultado['codigo']} - ${resultado['nome']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sistema: ${resultado['sistema_nome']}'),
                            if (resultado['descricao'] != null)
                              Text(
                                resultado['descricao'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/classification_details',
                            arguments: {
                              'resultado': resultado,
                              'osso': osso,
                              'parametros': parametros,
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Botão para salvar no histórico
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Concluir e Salvar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
