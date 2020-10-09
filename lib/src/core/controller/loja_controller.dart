import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/core/repository/loja_repository.dart';

part 'loja_controller.g.dart';

class LojaController = LojaControllerBase with _$LojaController;

abstract class LojaControllerBase with Store {
  LojaRepository _lojaRepository;

  LojaControllerBase() {
    _lojaRepository = LojaRepository();
  }

  @observable
  List<Loja> lojas;

  @observable
  int loja;

  @observable
  Exception error;

  @action
  Future<List<Loja>> getAll() async {
    try {
      lojas = await _lojaRepository.getAll();
      return lojas;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Loja p) async {
    try {
      loja = await _lojaRepository.create(p.toJson());
      return loja;
    } catch (e) {
      error = e;
    }
  }
}
