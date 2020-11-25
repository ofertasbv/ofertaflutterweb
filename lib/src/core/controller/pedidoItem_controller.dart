import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/pedidoitem.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/core/repository/pedidoItem_repository.dart';

part 'pedidoItem_controller.g.dart';

class PedidoItemController = PedidoItemControllerBase
    with _$PedidoItemController;

abstract class PedidoItemControllerBase with Store {
  PedidoItemRepository _pedidoItemRepository;

  PedidoItemControllerBase() {
    _pedidoItemRepository = PedidoItemRepository();
  }

  @observable
  double total = 0;

  @observable
  List<PedidoItem> pedidoItens;

  @observable
  int pedidoitem;

  @observable
  Exception error;

  @observable
  DioError dioError;

  @observable
  String mensagem;

  @action
  Future<List<PedidoItem>> getAll() async {
    try {
      pedidoItens = await _pedidoItemRepository.getAll();
      return pedidoItens;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(PedidoItem p) async {
    try {
      pedidoitem = await _pedidoItemRepository.create(p.toJson());
      if (pedidoitem == null) {
        mensagem = "sem dados";
      } else {
        return pedidoitem;
      }
    } on DioError catch (e) {
      mensagem = e.message;
      dioError = e;
    }
  }

  @action
  Future<int> update(int id, PedidoItem p) async {
    try {
      pedidoitem = await _pedidoItemRepository.update(id, p.toJson());
      return pedidoitem;
    } on DioError catch (e) {
      mensagem = e.message;
      dioError = e;
    }
  }


  @action
  adicionar(PedidoItem item) {
    item.quantidade = 1;
    item.valorUnitario = item.produto.estoque.valor;
    item.valorTotal = item.quantidade * item.valorUnitario;
    pedidoItens.add(item);
    calculateTotal();
  }

  @action
  isExiste(Produto p) {
    var result = false;
    for (PedidoItem p in pedidoItens) {
      if (p.produto.id == p.id) {
        return result = true;
      }
    }
    return result;
  }

  @action
  incremento(PedidoItem item) {
    if (item.quantidade < 10) {
      item.quantidade++;
    }
    calculateTotal();
  }

  @action
  decremento(PedidoItem item) {
    if (item.quantidade > 1) {
      item.quantidade--;
    }
    calculateTotal();
  }

  @action
  remove(PedidoItem item) {
    pedidoItens.remove(item);
    calculateTotal();
  }

  @action
  calculateTotal() {
    total = 0;
    pedidoItens.forEach((p) {
      total += p.valorTotal;
    });
    return total;
  }

}
