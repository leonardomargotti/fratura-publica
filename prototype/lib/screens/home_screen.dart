import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Logo ou ícone do aplicativo
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Título do aplicativo
              const Text(
                AppConstants.appTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 10),
              
              // Subtítulo do aplicativo
              const Text(
                AppConstants.appSubtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 50),
              
              // Botão para classificar nova fratura
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/select_bone');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  AppConstants.homeClassifyButton,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Botão para consultar banco de dados
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/database_query');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  AppConstants.homeDatabaseButton,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Botão para referências e informações
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/references');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                ),
                child: const Text(
                  AppConstants.homeReferencesButton,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              
              const Spacer(),
              
              // Versão do aplicativo
              const Text(
                'Versão 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
