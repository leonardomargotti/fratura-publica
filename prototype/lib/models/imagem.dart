import 'tipo_fratura.dart';
import 'dart:typed_data';

class Imagem {
  final int id;
  final int tipoFraturaId;
  final String nomeArquivo;
  final Uint8List? dados;
  final String? descricao;
  final String? tipoImagem;
  
  TipoFratura? tipoFratura;
  
  Imagem({
    required this.id,
    required this.tipoFraturaId,
    required this.nomeArquivo,
    this.dados,
    this.descricao,
    this.tipoImagem,
    this.tipoFratura,
  });
  
  factory Imagem.fromMap(Map<String, dynamic> map) {
    return Imagem(
      id: map['id'] as int,
      tipoFraturaId: map['tipo_fratura_id'] as int,
      nomeArquivo: map['nome_arquivo'] as String,
      dados: map['dados'] as Uint8List?,
      descricao: map['descricao'] as String?,
      tipoImagem: map['tipo_imagem'] as String?,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo_fratura_id': tipoFraturaId,
      'nome_arquivo': nomeArquivo,
      'dados': dados,
      'descricao': descricao,
      'tipo_imagem': tipoImagem,
    };
  }
  
  @override
  String toString() {
    return 'Imagem(id: $id, nomeArquivo: $nomeArquivo)';
  }
}
