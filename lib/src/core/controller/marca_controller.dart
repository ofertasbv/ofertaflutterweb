import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/marca.dart';
import 'package:nosso/src/core/repository/marca_repository.dart';

part 'marca_controller.g.dart';

class MarcaController = MarcaControllerBase with _$MarcaController;

abstract class MarcaControllerBase with Store {
  MarcaRepository _marcaRepository;

  MarcaControllerBase() {
    _marcaRepository = MarcaRepository();
  }

  @observable
  List<Marca> marcas;

  @observable
  int marca;

  @observable
  Exception error;

  @action
  Future<List<Marca>> getAll() async {
    try {
      marcas = await _marcaRepository.getAll();
      return marcas;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Marca p) async {
    try {
      marca = await _marcaRepository.create(p.toJson());
      return marca;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> update(int id, Marca p) async {
    try {
      marca = await _marcaRepository.update(id, p.toJson());
      return marca;
    } catch (e) {
      error = e;
    }
  }
}
