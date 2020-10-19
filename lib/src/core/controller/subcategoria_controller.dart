import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/subcategoria.dart';
import 'package:nosso/src/core/repository/subcategoria_repository.dart';

part 'subcategoria_controller.g.dart';

class SubCategoriaController = SubCategoriaControllerBase
    with _$SubCategoriaController;

abstract class SubCategoriaControllerBase with Store {
  SubCategoriaRepository _subCategoriaRepository;

  SubCategoriaControllerBase() {
    _subCategoriaRepository = SubCategoriaRepository();
  }

  @observable
  List<SubCategoria> subCategorias;

  @observable
  int subCategoria;

  @observable
  Exception error;

  @action
  Future<List<SubCategoria>> getAll() async {
    try {
      subCategorias = await _subCategoriaRepository.getAll();
      return subCategorias;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<SubCategoria>> getAllByCategoriaById(int id) async {
    try {
      subCategorias = await _subCategoriaRepository.getAllByCategoriaById(id);
      return subCategorias;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(SubCategoria p) async {
    try {
      subCategoria = await _subCategoriaRepository.create(p.toJson());
      return subCategoria;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> update(int id, SubCategoria p) async {
    try {
      subCategoria = await _subCategoriaRepository.update(id, p.toJson());
      return subCategoria;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<void> deleteFoto(String foto) async {
    try {
      await _subCategoriaRepository.deleteFoto(foto);
    } catch (e) {
      error = e;
    }
  }
}
