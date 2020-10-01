import 'package:nosso/src/core/model/arquivo.dart';
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
  DateTime dataRegistro;
  String codigoBarra;
  bool status;
  bool novo;
  bool destaque;
  String medida;
  String origem;
  String tamanho;
  String cor;
  double desconto;
  SubCategoria subCategoria;
  List<Promocao> promocaos;
  Loja loja;
  List<Arquivo> arquivos;
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
      this.arquivos,
      this.estoque,
      this.marca});

  Produto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];
    nome = json['nome'];
    descricao = json['descricao'];
    foto = json['foto'];
    favorito = json['favorito'];
    dataRegistro = DateTime.tryParse(json['dataRegistro'].toString());
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
    if (json['arquivos'] != null) {
      arquivos = new List<Arquivo>();
      json['arquivos'].forEach((v) {
        arquivos.add(new Arquivo.fromJson(v));
      });
    }
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
    data['dataRegistro'] = this.dataRegistro.toIso8601String();
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
    if (this.arquivos != null) {
      data['arquivos'] = this.arquivos.map((v) => v.toJson()).toList();
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
