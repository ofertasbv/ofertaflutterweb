import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/pedidoitem.dart';
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
  List<PedidoItem> pedidoitens;

  @observable
  int pedidoitem;

  @observable
  Exception error;

  @action
  Future<List<PedidoItem>> getAll() async {
    try {
      pedidoitens = await _pedidoItemRepository.getAll();
      return pedidoitens;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(PedidoItem p) async {
    try {
      pedidoitem = await _pedidoItemRepository.create(p.toJson());
      return pedidoitem;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> update(int id, PedidoItem p) async {
    try {
      pedidoitem = await _pedidoItemRepository.update(id, p.toJson());
      return pedidoitem;
    } catch (e) {
      error = e;
    }
  }
}
