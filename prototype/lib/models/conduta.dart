import 'tratamento.dart';

class Conduta {
  final int id;
  final int tratamentoId;
  final String descricao;
  final int? ordem;
  
  Tratamento? tratamento;
  
  Conduta({
    required this.id,
    required this.tratamentoId,
    required this.descricao,
    this.ordem,
    this.tratamento,
  });
  
  factory Conduta.fromMap(Map<String, dynamic> map) {
    return Conduta(
      id: map['id'] as int,
      tratamentoId: map['tratamento_id'] as int,
      descricao: map['descricao'] as String,
      ordem: map['ordem'] as int?,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tratamento_id': tratamentoId,
      'descricao': descricao,
      'ordem': ordem,
    };
  }
  
  @override
  String toString() {
    return 'Conduta(id: $id, descricao: $descricao, ordem: $ordem)';
  }
}
