class HistoricoClassificacao {
  final int id;
  final String dataHora;
  final String parametros;
  final String resultados;
  final String? notas;
  final int sincronizado;
  
  HistoricoClassificacao({
    required this.id,
    required this.dataHora,
    required this.parametros,
    required this.resultados,
    this.notas,
    required this.sincronizado,
  });
  
  factory HistoricoClassificacao.fromMap(Map<String, dynamic> map) {
    return HistoricoClassificacao(
      id: map['id'] as int,
      dataHora: map['data_hora'] as String,
      parametros: map['parametros'] as String,
      resultados: map['resultados'] as String,
      notas: map['notas'] as String?,
      sincronizado: map['sincronizado'] as int,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data_hora': dataHora,
      'parametros': parametros,
      'resultados': resultados,
      'notas': notas,
      'sincronizado': sincronizado,
    };
  }
  
  @override
  String toString() {
    return 'HistoricoClassificacao(id: $id, dataHora: $dataHora)';
  }
}
