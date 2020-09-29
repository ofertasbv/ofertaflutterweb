

import 'package:nosso/src/core/model/estoque.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/core/model/marca.dart';
import 'package:nosso/src/core/model/promocao.dart';
import 'package:nosso/src/core/model/subcategoria.dart';

class Produto {
  int id;
  String sku;
  String nome;
  String descricao;
  String foto;
  bool favorito;
  String dataRegistro;
  String codigoBarra;
  bool status;
  bool novo;
  bool destaque;
  String medida;
  String origem;
  String tamanho;
  String cor;
  int desconto;
  SubCategoria subCategoria;
  List<Promocao> promocaos;
  Loja loja;
  Estoque estoque;
  Marca marca;

  Produto(
      {this.id,
      this.sku,
      this.nome,
      this.descricao,
      this.foto,
      this.favorito,
      this.dataRegistro,
      this.codigoBarra,
      this.status,
      this.novo,
      this.destaque,
      this.medida,
      this.origem,
      this.tamanho,
      this.cor,
      this.desconto,
      this.subCategoria,
      this.promocaos,
      this.loja,
      this.estoque,
      this.marca});

  Produto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];
    nome = json['nome'];
    descricao = json['descricao'];
    foto = json['foto'];
    favorito = json['favorito'];
    dataRegistro = json['dataRegistro'];
    codigoBarra = json['codigoBarra'];
    status = json['status'];
    novo = json['novo'];
    destaque = json['destaque'];
    medida = json['medida'];
    origem = json['origem'];
    tamanho = json['tamanho'];
    cor = json['cor'];
    desconto = json['desconto'];
    subCategoria = json['subCategoria'] != null
        ? new SubCategoria.fromJson(json['subCategoria'])
        : null;
    if (json['promocaos'] != null) {
      promocaos = new List<Promocao>();
      json['promocaos'].forEach((v) {
        promocaos.add(new Promocao.fromJson(v));
      });
    }
    loja = json['loja'] != null ? new Loja.fromJson(json['loja']) : null;
    estoque =
        json['estoque'] != null ? new Estoque.fromJson(json['estoque']) : null;
    marca = json['marca'] != null ? new Marca.fromJson(json['marca']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sku'] = this.sku;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['foto'] = this.foto;
    data['favorito'] = this.favorito;
    data['dataRegistro'] = this.dataRegistro;
    data['codigoBarra'] = this.codigoBarra;
    data['status'] = this.status;
    data['novo'] = this.novo;
    data['destaque'] = this.destaque;
    data['medida'] = this.medida;
    data['origem'] = this.origem;
    data['tamanho'] = this.tamanho;
    data['cor'] = this.cor;
    data['desconto'] = this.desconto;
    if (this.subCategoria != null) {
      data['subCategoria'] = this.subCategoria.toJson();
    }
    if (this.promocaos != null) {
      data['promocaos'] = this.promocaos.map((v) => v.toJson()).toList();
    }
    if (this.loja != null) {
      data['loja'] = this.loja.toJson();
    }
    if (this.estoque != null) {
      data['estoque'] = this.estoque.toJson();
    }
    if (this.marca != null) {
      data['marca'] = this.marca.toJson();
    }
    return data;
  }
}
