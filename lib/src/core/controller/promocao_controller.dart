import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/promocao.dart';
import 'package:nosso/src/core/repository/promocao_repository.dart';

part 'promocao_controller.g.dart';

class PromoCaoController = PromoCaoControllerBase with _$PromoCaoController;

abstract class PromoCaoControllerBase with Store {
  PromocaoRepository _promocaoRepository;

  PromoCaoControllerBase() {
    _promocaoRepository = PromocaoRepository();
  }

  @observable
  List<Promocao> promocoes;

  @observable
  int promocao;

  @observable
  Exception error;

  @action
  Future<List<Promocao>> getAll() async {
    try {
      promocoes = await _promocaoRepository.getAll();
      return promocoes;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Promocao p) async {
    try {
      promocao = await _promocaoRepository.create(p.toJson());
      return promocao;
    } catch (e) {
      error = e;
    }
  }
}
