
class Tamanho {
  int id;
  String descricao;
  String numeracao;

  Tamanho({this.id, this.descricao, this.numeracao});

  Tamanho.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    numeracao = json['numeracao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['numeracao'] = this.numeracao;
    return data;
  }
}