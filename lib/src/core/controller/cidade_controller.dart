import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/cidade.dart';
import 'package:nosso/src/core/repository/cidade_repository.dart';

part 'cidade_controller.g.dart';

class CidadeController = CidadeControllerBase with _$CidadeController;

abstract class CidadeControllerBase with Store {
  CidadeRepository _cidadeRepository;

  CidadeControllerBase() {
    _cidadeRepository = CidadeRepository();
  }

  @observable
  List<Cidade> cidades;

  @observable
  int cidade;

  @observable
  Exception error;

  @action
  Future<List<Cidade>> getAll() async {
    try {
      cidades = await _cidadeRepository.getAll();
      return cidades;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<Cidade>> getAllById(int id) async {
    try {
      cidades = await _cidadeRepository.getAllById(id);
      return cidades;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<Cidade>> getAllByEstadoId(int id) async {
    try {
      cidades = await _cidadeRepository.getAllByEstadoId(id);
      return cidades;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Cidade p) async {
    try {
      cidade = await _cidadeRepository.create(p.toJson());
      return cidade;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> update(int id, Cidade p) async {
    try {
      cidade = await _cidadeRepository.update(id, p.toJson());
      return cidade;
    } catch (e) {
      error = e;
    }
  }
}
