class SistemaClassificacao {
  final int id;
  final String nome;
  final String? descricao;
  final String? referencia;
  
  SistemaClassificacao({
    required this.id,
    required this.nome,
    this.descricao,
    this.referencia,
  });
  
  factory SistemaClassificacao.fromMap(Map<String, dynamic> map) {
    return SistemaClassificacao(
      id: map['id'] as int,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String?,
      referencia: map['referencia'] as String?,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'referencia': referencia,
    };
  }
  
  @override
  String toString() {
    return 'SistemaClassificacao(id: $id, nome: $nome)';
  }
}
