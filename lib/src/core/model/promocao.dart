

import 'package:nosso/src/core/model/loja.dart';

class Promocao {
  int id;
  String nome;
  String descricao;
  String foto;
  double desconto;
  String dataRegistro;
  String dataInicio;
  String dataFinal;
  Loja loja;

  Promocao(
      {this.id,
        this.nome,
        this.descricao,
        this.foto,
        this.desconto,
        this.dataRegistro,
        this.dataInicio,
        this.dataFinal,
        this.loja});

  Promocao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    foto = json['foto'];
    desconto = json['desconto'];
    dataRegistro = json['dataRegistro'];
    dataInicio = json['dataInicio'];
    dataFinal = json['dataFinal'];
    loja = json['loja'] != null ? new Loja.fromJson(json['loja']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['foto'] = this.foto;
    data['desconto'] = this.desconto;
    data['dataRegistro'] = this.dataRegistro;
    data['dataInicio'] = this.dataInicio;
    data['dataFinal'] = this.dataFinal;
    if (this.loja != null) {
      data['loja'] = this.loja.toJson();
    }
    return data;
  }
}