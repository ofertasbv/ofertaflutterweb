class CaixaFluxoSaida {
  int id;
  String descricao;
  double valorSaida;
  DateTime dataRegistro;

  CaixaFluxoSaida({
    this.id,
    this.descricao,
    this.valorSaida,
    this.dataRegistro,
  });

  CaixaFluxoSaida.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    valorSaida = json['valorSaida'];
    dataRegistro = DateTime.tryParse(json['dataRegistro'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['valorSaida'] = this.valorSaida;
    data['dataRegistro'] = this.dataRegistro.toIso8601String();
    return data;
  }
}
