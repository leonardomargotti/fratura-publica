import 'parametro_classificacao.dart';

class ValorParametro {
  final int id;
  final int parametroId;
  final String valor;
  final String? descricao;
  
  ParametroClassificacao? parametro;
  
  ValorParametro({
    required this.id,
    required this.parametroId,
    required this.valor,
    this.descricao,
    this.parametro,
  });
  
  factory ValorParametro.fromMap(Map<String, dynamic> map) {
    return ValorParametro(
      id: map['id'] as int,
      parametroId: map['parametro_id'] as int,
      valor: map['valor'] as String,
      descricao: map['descricao'] as String?,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parametro_id': parametroId,
      'valor': valor,
      'descricao': descricao,
    };
  }
  
  @override
  String toString() {
    return 'ValorParametro(id: $id, valor: $valor)';
  }
}
