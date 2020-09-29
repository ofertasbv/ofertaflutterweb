import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/arquivo.dart';
import 'package:nosso/src/core/repository/arquivo_repository.dart';


part 'arquivo_controller.g.dart';

class ArquivoController = ArquivoControllerBase with _$ArquivoController;

abstract class ArquivoControllerBase with Store {
  ArquivoRepository _arquivoRepository;

  ArquivoControllerBase() {
    _arquivoRepository = ArquivoRepository();
  }

  @observable
  List<Arquivo> arquivos;

  @observable
  int arquivo;

  @observable
  Exception error;

  @action
  Future<List<Arquivo>> getAll() async {
    try {
      arquivos = await _arquivoRepository.getAll();
      return arquivos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Arquivo p) async {
    try {
      arquivo = await _arquivoRepository.create(p.toJson());
      return arquivo;
    } catch (e) {
      error = e;
    }
  }
}
