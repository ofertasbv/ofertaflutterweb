import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/estado.dart';
import 'package:nosso/src/core/repository/estado_repository.dart';

part 'estado_controller.g.dart';

class EstadoController = EstadoControllerBase with _$EstadoController;
abstract class EstadoControllerBase with Store{
  EstadoRepository _estadoRepository;

  EstadoControllerBase() {
    _estadoRepository = EstadoRepository();
  }

  @observable
  List<Estado> estados;

  @observable
  int estado;

  @observable
  Exception error;

  @action
  Future<List<Estado>> getAll() async {
    try {
      estados = await _estadoRepository.getAll();
      return estados;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Estado p) async {
    try {
      estado = await _estadoRepository.create(p.toJson());
      return estado;
    } catch (e) {
      error = e;
    }
  }
}