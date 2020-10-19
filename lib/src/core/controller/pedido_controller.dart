import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/pedido.dart';
import 'package:nosso/src/core/repository/pedido_repository.dart';

part 'pedido_controller.g.dart';

class PedidoController = PedidoControllerBase with _$PedidoController;

abstract class PedidoControllerBase with Store {
  PedidoRepository _pedidoRepository;

  PedidoControllerBase() {
    _pedidoRepository = PedidoRepository();
  }

  @observable
  List<Pedido> pedidos;

  @observable
  int pedido;

  @observable
  Exception error;

  @action
  Future<List<Pedido>> getAll() async {
    try {
      pedidos = await _pedidoRepository.getAll();
      return pedidos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Pedido p) async {
    try {
      pedido = await _pedidoRepository.create(p.toJson());
      return pedido;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> update(int id, Pedido p) async {
    try {
      pedido = await _pedidoRepository.update(id, p.toJson());
      return pedido;
    } catch (e) {
      error = e;
    }
  }
}
