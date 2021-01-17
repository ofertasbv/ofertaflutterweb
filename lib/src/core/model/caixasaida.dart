class CaixaFluxoSaida {
  int id;
  String nome;
  String numeroCartao;
  String numeroSeguranca;
  DateTime dataValidade;

  CaixaFluxoSaida({
    this.id,
    this.nome,
    this.numeroCartao,
    this.numeroSeguranca,
    this.dataValidade,
  });

  CaixaFluxoSaida.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    numeroCartao = json['numeroCartao'];
    numeroSeguranca = json['numeroSeguranca'];
    dataValidade = DateTime.tryParse(json['dataValidade'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['numeroCartao'] = this.numeroCartao;
    data['numeroSeguranca'] = this.numeroSeguranca;
    data['dataValidade'] = this.dataValidade.toIso8601String();
    return data;
  }
}
