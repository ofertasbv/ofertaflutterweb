import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/core/repository/produto_repository.dart';
import 'package:nosso/src/util/filter/produto_filter.dart';

part 'produto_controller.g.dart';

class ProdutoController = ProdutoControllerBase with _$ProdutoController;

abstract class ProdutoControllerBase with Store {
  ProdutoRepository _produtoRepository;

  ProdutoControllerBase() {
    _produtoRepository = ProdutoRepository();
  }

  @observable
  List<Produto> produtos;

  @observable
  int produto;

  @observable
  Exception error;

  @action
  Future<List<Produto>> getAll() async {
    try {
      produtos = await _produtoRepository.getAll();
      return produtos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<Produto>> getFilter(ProdutoFilter filter) async {
    try {
      produtos = await _produtoRepository.getFilter(filter);
      return produtos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Produto p) async {
    try {
      produto = await _produtoRepository.create(p.toJson());
      return produto;
    } catch (e) {
      error = e;
    }
  }
}
