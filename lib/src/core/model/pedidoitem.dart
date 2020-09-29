

import 'package:nosso/src/core/model/produto.dart';

class PedidoItem {
  int id;
  int valorUnitario;
  int quantidade;
  String dataRegistro;
  Produto produto;
  int valorTotal;
  bool estoqueSuficiente;
  bool produtoAssociado;
  bool estoqueInsuficiente;

  PedidoItem(
      {this.id,
      this.valorUnitario,
      this.quantidade,
      this.dataRegistro,
      this.produto,
      this.valorTotal,
      this.estoqueSuficiente,
      this.produtoAssociado,
      this.estoqueInsuficiente});

  PedidoItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    valorUnitario = json['valorUnitario'];
    quantidade = json['quantidade'];
    dataRegistro = json['dataRegistro'];
    produto =
        json['produto'] != null ? new Produto.fromJson(json['produto']) : null;
    valorTotal = json['valorTotal'];
    estoqueSuficiente = json['estoqueSuficiente'];
    produtoAssociado = json['produtoAssociado'];
    estoqueInsuficiente = json['estoqueInsuficiente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['valorUnitario'] = this.valorUnitario;
    data['quantidade'] = this.quantidade;
    data['dataRegistro'] = this.dataRegistro;
    if (this.produto != null) {
      data['produto'] = this.produto.toJson();
    }
    data['valorTotal'] = this.valorTotal;
    data['estoqueSuficiente'] = this.estoqueSuficiente;
    data['produtoAssociado'] = this.produtoAssociado;
    data['estoqueInsuficiente'] = this.estoqueInsuficiente;
    return data;
  }
}
