import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/cor.dart';
import 'package:nosso/src/core/repository/cor_repository.dart';

part 'cor_controller.g.dart';

class CorController = CorControllerBase with _$CorController;

abstract class CorControllerBase with Store {
  CorRepository _corRepository;

  CorControllerBase() {
    _corRepository = CorRepository();
  }

  @observable
  List<Cor> cores;

  @observable
  int cor;

  @observable
  Exception error;

  @action
  Future<List<Cor>> getAll() async {
    try {
      cores = await _corRepository.getAll();
      return cores;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Cor p) async {
    try {
      cor = await _corRepository.create(p.toJson());
      return cor;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> update(int id, Cor p) async {
    try {
      cor = await _corRepository.update(id, p.toJson());
      return cor;
    } catch (e) {
      error = e;
    }
  }
}
