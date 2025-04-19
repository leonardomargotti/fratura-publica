import 'tipo_fratura.dart';
import 'parametro_classificacao.dart';
import 'valor_parametro.dart';

class RegraClassificacao {
  final int id;
  final int tipoFraturaId;
  final int parametroId;
  final int valorParametroId;
  
  TipoFratura? tipoFratura;
  ParametroClassificacao? parametro;
  ValorParametro? valorParametro;
  
  RegraClassificacao({
    required this.id,
    required this.tipoFraturaId,
    required this.parametroId,
    required this.valorParametroId,
    this.tipoFratura,
    this.parametro,
    this.valorParametro,
  });
  
  factory RegraClassificacao.fromMap(Map<String, dynamic> map) {
    return RegraClassificacao(
      id: map['id'] as int,
      tipoFraturaId: map['tipo_fratura_id'] as int,
      parametroId: map['parametro_id'] as int,
      valorParametroId: map['valor_parametro_id'] as int,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo_fratura_id': tipoFraturaId,
      'parametro_id': parametroId,
      'valor_parametro_id': valorParametroId,
    };
  }
  
  @override
  String toString() {
    return 'RegraClassificacao(id: $id, tipoFraturaId: $tipoFraturaId, parametroId: $parametroId, valorParametroId: $valorParametroId)';
  }
}
