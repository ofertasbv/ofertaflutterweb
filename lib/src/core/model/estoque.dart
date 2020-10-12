class Estoque {
  int id;
  int quantidade;
  double valor;

  Estoque({this.id, this.quantidade, this.valor});

  Estoque.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantidade = int.tryParse(json['quantidade'].toString());
    valor = double.tryParse(json['valor'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantidade'] = this.quantidade.toString();
    data['valor'] = this.valor.toString();
    return data;
  }
}
