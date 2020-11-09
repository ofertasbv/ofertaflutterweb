
class Tamanho {
  int id;
  String descricao;
  bool status;

  Tamanho({this.id, this.descricao});

  Tamanho.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['status'] = this.status;
    return data;
  }
}