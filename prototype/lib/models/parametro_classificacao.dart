class ParametroClassificacao {
  final int id;
  final String nome;
  final String? descricao;
  
  ParametroClassificacao({
    required this.id,
    required this.nome,
    this.descricao,
  });
  
  factory ParametroClassificacao.fromMap(Map<String, dynamic> map) {
    return ParametroClassificacao(
      id: map['id'] as int,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String?,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }
  
  @override
  String toString() {
    return 'ParametroClassificacao(id: $id, nome: $nome)';
  }
}
