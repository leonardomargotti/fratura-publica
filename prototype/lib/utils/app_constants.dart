import 'package:flutter/material.dart';

class AppConstants {
  // Cores
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF03A9F4);
  static const Color accentColor = Color(0xFF4CAF50);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color medicalGreen = Color(0xFF4CAF50);

  // Dimensões
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 2.0;

  // Textos do aplicativo
  static const String appTitle = 'Classificador de Fraturas';
  static const String appSubtitle = 'Auxílio para classificação de fraturas ortopédicas';
  
  // Botões da tela inicial
  static const String homeClassifyButton = 'Classificar Nova Fratura';
  static const String homeDatabaseButton = 'Consultar Banco de Dados';
  static const String homeReferencesButton = 'Referências e Informações';
  
  // Tela de seleção de osso
  static const String selectBoneTitle = 'Selecione o Osso';
  static const String selectBoneSubtitle = 'Selecione o osso afetado pela fratura:';
  
  // Tela de parâmetros de fratura
  static const String fractureParametersTitle = 'Parâmetros da Fratura';
  static const String boneRegionLabel = 'Região do Osso';
  static const String fractureTypeLabel = 'Tipo de Traço';
  static const String exposureLabel = 'Exposição';
  static const String patientAgeLabel = 'Idade do Paciente';
  static const String displacementLabel = 'Deslocamento';
  static const String comminutionLabel = 'Cominuição';
  static const String articularLabel = 'Articular';
  
  // Valores de parâmetros
  static const String proximalRegion = 'Proximal';
  static const String diaphysealRegion = 'Diafisária';
  static const String distalRegion = 'Distal';
  
  static const String transverseFracture = 'Transverso';
  static const String obliqueFracture = 'Oblíquo';
  static const String spiralFracture = 'Espiral';
  static const String comminutedFracture = 'Cominutivo';
  static const String segmentalFracture = 'Segmentar';
  
  static const String closedFracture = 'Fechada';
  static const String openFracture = 'Exposta';
  
  static const String adultPatient = 'Adulto';
  static const String childPatient = 'Criança';
  
  static const String noDisplacement = 'Sem deslocamento';
  static const String partialDisplacement = 'Deslocamento parcial';
  static const String completeDisplacement = 'Deslocamento completo';
  
  static const String yes = 'Sim';
  static const String no = 'Não';
  
  // Botões de ação
  static const String continueButton = 'Continuar';
  static const String classifyButton = 'Classificar Fratura';
  static const String viewDetailsButton = 'Ver Detalhes';
  static const String viewMoreImagesButton = 'Ver Mais Imagens';
  static const String viewTreatmentDetailsButton = 'Detalhes do Tratamento';
  static const String moreReferencesButton = 'Mais Referências';
  static const String aboutAppButton = 'Sobre o Aplicativo';
  
  // Tela de resultados
  static const String resultsTitle = 'Resultados da Classificação';
  static const String applicableClassifications = 'Classificações Aplicáveis';
  
  // Tela de detalhes
  static const String detailsTitle = 'Detalhes';
  static const String descriptionLabel = 'Descrição';
  static const String radiographicFeaturesLabel = 'Características Radiográficas';
  static const String suggestedTreatmentsLabel = 'Tratamentos Sugeridos';
  
  // Tela de tratamento
  static const String indicationsLabel = 'Indicações';
  static const String contraindicationsLabel = 'Contraindicações';
  static const String proceduresLabel = 'Procedimentos';
  static const String possibleComplicationsLabel = 'Possíveis Complicações';
  
  // Tela de consulta ao banco de dados
  static const String databaseQueryTitle = 'Consulta ao Banco de Dados';
  static const String searchHint = 'Pesquisar por classificação, osso, tipo...';
  static const String filterByLabel = 'Filtrar por:';
  static const String classificationSystemLabel = 'Sistema de Classificação';
  static const String boneLabel = 'Osso';
  
  // Tela de referências
  static const String referencesTitle = 'Referências';
  static const String classificationSystemsLabel = 'Sistemas de Classificação';
  
  // Mensagens de erro
  static const String errorLoadingData = 'Erro ao carregar dados. Verifique sua conexão e tente novamente.';
  static const String errorClassifying = 'Erro ao classificar fratura. Verifique os parâmetros e tente novamente.';
}
