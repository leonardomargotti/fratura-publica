class Osso {
  final int id;
  final String nome;
  final String? regiao;
  final String? descricao;
  
  Osso({
    required this.id,
    required this.nome,
    this.regiao,
    this.descricao,
  });
  
  factory Osso.fromMap(Map<String, dynamic> map) {
    return Osso(
      id: map['id'] as int,
      nome: map['nome'] as String,
      regiao: map['regiao'] as String?,
      descricao: map['descricao'] as String?,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'regiao': regiao,
      'descricao': descricao,
    };
  }
  
  @override
  String toString() {
    return 'Osso(id: $id, nome: $nome, regiao: $regiao)';
  }
}
