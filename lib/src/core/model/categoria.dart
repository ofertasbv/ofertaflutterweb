import 'package:nosso/src/core/model/subcategoria.dart';

class Categoria {
  int id;
  String nome;
  String foto;
  List<SubCategoria> subCategorias;

  Categoria({this.id, this.nome, this.foto});

  Categoria.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    foto = json['foto'];

    if (json['subCategorias'] != null) {
      subCategorias = new List<SubCategoria>();
      json['subCategorias'].forEach((v) {
        subCategorias.add(new SubCategoria.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['foto'] = this.foto;
    return data;
  }
}
