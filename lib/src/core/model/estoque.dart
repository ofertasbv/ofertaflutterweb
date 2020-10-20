class Estoque {
  int id;
  int quantidade;
  double valor;

  Estoque({this.id, this.quantidade, this.valor});

  Estoque.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantidade = json['quantidade'] + 0;
    valor = json['valor'] + 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantidade'] = this.quantidade.toString();
    data['valor'] = this.valor.toString();
    return data;
  }
}
