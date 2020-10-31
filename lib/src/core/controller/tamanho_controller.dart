
import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/tamanho.dart';
import 'package:nosso/src/core/repository/tamanho_repository.dart';

part 'tamanho_controller.g.dart';

class TamanhoController = TamanhoControllerBase with _$TamanhoController;
abstract class TamanhoControllerBase with Store{

  TamanhoRepository _tamanhoRepository;

  TamanhoControllerBase() {
    _tamanhoRepository = TamanhoRepository();
  }

  @observable
  List<Tamanho> tamanhos;

  @observable
  int tamanho;

  @observable
  Exception error;

  @action
  Future<List<Tamanho>> getAll() async {
    try {
      tamanhos = await _tamanhoRepository.getAll();
      return tamanhos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Tamanho p) async {
    try {
      tamanho = await _tamanhoRepository.create(p.toJson());
      return tamanho;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> update(int id, Tamanho p) async {
    try {
      tamanho = await _tamanhoRepository.update(id, p.toJson());
      return tamanho;
    } catch (e) {
      error = e;
    }
  }

}