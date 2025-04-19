import 'tipo_fratura.dart';

class Tratamento {
  final int id;
  final int tipoFraturaId;
  final String nome;
  final String? descricao;
  final String? indicacoes;
  final String? contraindicacoes;
  
  TipoFratura? tipoFratura;
  
  Tratamento({
    required this.id,
    required this.tipoFraturaId,
    required this.nome,
    this.descricao,
    this.indicacoes,
    this.contraindicacoes,
    this.tipoFratura,
  });
  
  factory Tratamento.fromMap(Map<String, dynamic> map) {
    return Tratamento(
      id: map['id'] as int,
      tipoFraturaId: map['tipo_fratura_id'] as int,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String?,
      indicacoes: map['indicacoes'] as String?,
      contraindicacoes: map['contraindicacoes'] as String?,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo_fratura_id': tipoFraturaId,
      'nome': nome,
      'descricao': descricao,
      'indicacoes': indicacoes,
      'contraindicacoes': contraindicacoes,
    };
  }
  
  @override
  String toString() {
    return 'Tratamento(id: $id, nome: $nome)';
  }
}
