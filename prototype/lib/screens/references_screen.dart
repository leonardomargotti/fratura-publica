import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

class ReferencesScreen extends StatelessWidget {
  const ReferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.referencesTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Referências e Informações',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              _buildSection(
                'Sistemas de Classificação',
                [
                  _buildReference(
                    'AO/OTA Classification',
                    'Sistema de classificação desenvolvido pela AO Foundation e Orthopaedic Trauma Association',
                    'https://www.aofoundation.org/trauma/clinical-library-and-tools/journals-and-publications/classification',
                  ),
                  _buildReference(
                    'Salter-Harris Classification',
                    'Sistema de classificação para fraturas fisárias em crianças',
                    'https://radiopaedia.org/articles/salter-harris-classification',
                  ),
                  _buildReference(
                    'Classificação de Neer',
                    'Sistema de classificação para fraturas do úmero proximal',
                    'https://ortopediaonline.med.br/classificacao-de-neer/',
                  ),
                  _buildReference(
                    'Classificação de Weber',
                    'Sistema de classificação para fraturas do tornozelo',
                    'https://ortopediaonline.med.br/classificacao-de-danis-weber/',
                  ),
                  _buildReference(
                    'Classificação de Garden',
                    'Sistema de classificação para fraturas do colo do fêmur',
                    'https://ortopediaonline.med.br/classificacao-de-garden/',
                  ),
                  _buildReference(
                    'Classificação de Schatzker',
                    'Sistema de classificação para fraturas do platô tibial',
                    'https://radiopaedia.org/articles/schatzker-classification-of-tibial-plateau-fractures-1',
                  ),
                ],
              ),
              
              _buildSection(
                'Sobre o Aplicativo',
                [
                  const ListTile(
                    title: Text('Versão'),
                    subtitle: Text('1.0.0'),
                  ),
                  const ListTile(
                    title: Text('Desenvolvido por'),
                    subtitle: Text('Equipe Manus'),
                  ),
                  const ListTile(
                    title: Text('Contato'),
                    subtitle: Text('suporte@classificadorfraturas.com.br'),
                  ),
                ],
              ),
              
              _buildSection(
                'Aviso Legal',
                [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Este aplicativo é uma ferramenta de apoio à decisão clínica e não substitui o julgamento médico profissional. As classificações, tratamentos e condutas sugeridos devem ser avaliados criticamente pelo profissional de saúde responsável pelo paciente, considerando as particularidades de cada caso.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Os desenvolvedores não se responsabilizam por decisões clínicas tomadas com base nas informações fornecidas por este aplicativo.',
                      style: TextStyle(fontSize: 14),
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
  
  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
  
  Widget _buildReference(String title, String description, String url) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      trailing: const Icon(Icons.open_in_new),
      onTap: () {
        // Abrir URL
      },
    );
  }
}
