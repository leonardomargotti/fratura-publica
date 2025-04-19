import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/select_bone_screen.dart';
import 'screens/fracture_parameters_screen.dart';
import 'screens/classification_results_screen.dart';
import 'screens/classification_details_screen.dart';
import 'screens/treatment_details_screen.dart';
import 'screens/database_query_screen.dart';
import 'screens/references_screen.dart';
import 'utils/app_theme.dart';
import 'utils/app_constants.dart';
import 'utils/connectivity_service.dart';
import 'utils/sync_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar serviços
  final connectivityService = ConnectivityService();
  await connectivityService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<ConnectivityService>.value(value: connectivityService),
        Provider<SyncManager>(create: (_) => SyncManager()),
      ],
      child: const FractureClassifierApp(),
    ),
  );
}

class FractureClassifierApp extends StatelessWidget {
  const FractureClassifierApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/select_bone': (context) => const SelectBoneScreen(),
        '/fracture_parameters': (context) => const FractureParametersScreen(),
        '/classification_results': (context) => const ClassificationResultsScreen(),
        '/classification_details': (context) => const ClassificationDetailsScreen(),
        '/treatment_details': (context) => const TreatmentDetailsScreen(),
        '/database_query': (context) => const DatabaseQueryScreen(),
        '/references': (context) => const ReferencesScreen(),
      },
      builder: (context, child) {
        return Column(
          children: [
            Expanded(child: child!),
            ConnectivityService.connectivityBanner(context),
          ],
        );
      },
    );
  }
}
