class Caixa {
  int id;
  String descricao;
  String referencia;
  DateTime dataRegistro;

  Caixa({
    this.id,
    this.descricao,
    this.referencia,
    this.dataRegistro,
  });

  Caixa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    referencia = json['referencia'];
    dataRegistro = DateTime.tryParse(json['dataRegistro'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['referencia'] = this.referencia;
    data['dataRegistro'] = this.dataRegistro.toIso8601String();
    return data;
  }
}
