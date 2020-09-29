class SubCategoria {
  int id;
  String nome;
  String foto;

  SubCategoria({this.id, this.nome, this.foto});

  SubCategoria.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['foto'] = this.foto;
    return data;
  }
}
