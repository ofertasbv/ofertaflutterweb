class Estoque {
  int id;
  String quantidade;
  String valor;

  Estoque({this.id, this.quantidade, this.valor});

  Estoque.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantidade = json['quantidade'];
    valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantidade'] = this.quantidade;
    data['valor'] = this.valor;
    return data;
  }
}
