import 'package:nosso/src/core/enum/caixa_status.dart';

class CaixaFluxo {
  int id;
  String descricao;
  double saldoAnterior;
  double valorEntrada;
  double valorSaida;
  double valorTotal;
  DateTime dataRegistro;
  CaixaStatus caixaStatus;

  CaixaFluxo({
    this.id,
    this.descricao,
    this.saldoAnterior,
    this.valorEntrada,
    this.valorSaida,
    this.valorTotal,
    this.dataRegistro,
    this.caixaStatus,
  });

  CaixaFluxo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    saldoAnterior = json['saldoAnterior'];
    valorEntrada = json['valorEntrada'];
    valorSaida = json['valorSaida'];
    valorTotal = json['valorTotal'];
    dataRegistro = DateTime.tryParse(json['dataRegistro'].toString());
    caixaStatus = json['caixaStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['saldoAnterior'] = this.saldoAnterior;
    data['valorEntrada'] = this.valorEntrada;
    data['valorSaida'] = this.valorSaida;
    data['dataRegistro'] = this.dataRegistro.toIso8601String();
    data['caixaStatus'] = this.caixaStatus;
    return data;
  }
}
