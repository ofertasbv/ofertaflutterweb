import 'package:nosso/src/core/model/cliente.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/core/model/pedidoitem.dart';

class Pedido {
  int id;
  String descricao;

  double valorFrete;
  double valorDesconto;
  double valorTotal;
  List<PedidoItem> pedidoItems;
  Cliente cliente;
  Loja loja;
  String statusPedido;
  String formaPagamento;
  DateTime dataHoraEntrega;
  DateTime dataEntrega;
  DateTime horarioEntrega;

  Pedido({
    this.id,
    this.descricao,
    this.valorFrete,
    this.valorDesconto,
    this.valorTotal,
    this.pedidoItems,
    this.cliente,
    this.loja,
    this.statusPedido,
    this.formaPagamento,
    this.dataHoraEntrega,
    this.dataEntrega,
    this.horarioEntrega,
  });

  Pedido.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];

    valorFrete = json['valorFrete'];
    valorDesconto = json['valorDesconto'];
    valorTotal = json['valorTotal'];

    if (json['pedidoItems'] != null) {
      pedidoItems = new List<PedidoItem>();
      json['pedidoItems'].forEach((v) {
        pedidoItems.add(new PedidoItem.fromJson(v));
      });
    }
    cliente =
        json['cliente'] != null ? new Cliente.fromJson(json['cliente']) : null;
    loja = json['loja'] != null ? new Loja.fromJson(json['loja']) : null;

    statusPedido = json['statusPedido'];
    formaPagamento = json['formaPagamento'];

    dataHoraEntrega = DateTime.tryParse(json['dataHoraEntrega'].toString());
    dataEntrega = DateTime.tryParse(json['dataEntrega'].toString());
    horarioEntrega = DateTime.tryParse(json['horarioEntrega'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;

    data['valorFrete'] = this.valorFrete;
    data['valorDesconto'] = this.valorDesconto;
    data['valorTotal'] = this.valorTotal;

    if (this.pedidoItems != null) {
      data['pedidoItems'] = this.pedidoItems.map((v) => v.toJson()).toList();
    }
    if (this.cliente != null) {
      data['cliente'] = this.cliente.toJson();
    }
    if (this.loja != null) {
      data['loja'] = this.loja.toJson();
    }

    data['statusPedido'] = this.statusPedido;
    data['formaPagamento'] = this.formaPagamento;

    data['dataHoraEntrega'] = this.dataHoraEntrega.toIso8601String();
    data['dataEntrega'] = this.dataEntrega.toIso8601String();
    data['horarioEntrega'] = this.horarioEntrega.toIso8601String();
    return data;
  }
}
