import 'osso.dart';
import 'sistema_classificacao.dart';

class TipoFratura {
  final int id;
  final int? ossoId;
  final int sistemaId;
  final String codigo;
  final String nome;
  final String? descricao;
  final String? caracteristicas;
  
  Osso? osso;
  SistemaClassificacao? sistema;
  
  TipoFratura({
    required this.id,
    this.ossoId,
    required this.sistemaId,
    required this.codigo,
    required this.nome,
    this.descricao,
    this.caracteristicas,
    this.osso,
    this.sistema,
  });
  
  factory TipoFratura.fromMap(Map<String, dynamic> map) {
    return TipoFratura(
      id: map['id'] as int,
      ossoId: map['osso_id'] as int?,
      sistemaId: map['sistema_id'] as int,
      codigo: map['codigo'] as String,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String?,
      caracteristicas: map['caracteristicas'] as String?,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'osso_id': ossoId,
      'sistema_id': sistemaId,
      'codigo': codigo,
      'nome': nome,
      'descricao': descricao,
      'caracteristicas': caracteristicas,
    };
  }
  
  @override
  String toString() {
    return 'TipoFratura(id: $id, codigo: $codigo, nome: $nome)';
  }
}
