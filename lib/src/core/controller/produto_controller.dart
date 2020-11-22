import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/model/cor.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/core/model/tamanho.dart';
import 'package:nosso/src/core/repository/produto_repository.dart';
import 'package:nosso/src/util/filter/produto_filter.dart';

part 'produto_controller.g.dart';

class ProdutoController = ProdutoControllerBase with _$ProdutoController;

abstract class ProdutoControllerBase with Store {
  ProdutoRepository produtoRepository;

  ProdutoControllerBase() {
    produtoRepository = ProdutoRepository();
  }

  @observable
  List<Produto> produtos;

  @observable
  int produto;

  @observable
  Produto produtoSelecionado;

  @observable
  String arquivo = ConstantApi.urlArquivoProduto;

  @observable
  var formData;

  @observable
  Exception error;

  @observable
  DioError dioError;

  @observable
  String mensagem;

  @observable
  ObservableList<Cor> coresSelecionada = ObservableList<Cor>();

  @observable
  ObservableList<Tamanho> tamanhosSelecionada = ObservableList<Tamanho>();

  @observable
  bool status = false;

  @action
  favoritar() {
    status = !status;
  }

  @action
  Future<List<Produto>> getAll() async {
    try {
      produtos = await produtoRepository.getAll();
      return produtos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<Produto>> getFilter(ProdutoFilter filter) async {
    try {
      produtos = await produtoRepository.getFilter(filter);
      return produtos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<Produto>> getAllBySubCategoriaById(int id) async {
    try {
      produtos = await produtoRepository.getAllBySubCategoriaById(id);
      return produtos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<Produto> getCodigoBarra(String codBarra) async {
    try {
      produtoSelecionado = await produtoRepository.getByCodBarra(codBarra);
      return produtoSelecionado;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Produto p) async {
    try {
      produto = await produtoRepository.create(p.toJson());
      if (produto == null) {
        mensagem = "sem dados";
      } else {
        return produto;
      }
    } on DioError catch (e) {
      mensagem = e.message;
      dioError = e;
    }
  }

  @action
  Future<int> update(int id, Produto p) async {
    try {
      produto = await produtoRepository.update(id, p.toJson());
      return produto;
    } on DioError catch (e) {
      mensagem = e.message;
      dioError = e;
    }
  }

  @action
  Future<String> upload(File foto, String fileName) async {
    try {
      formData = await produtoRepository.upload(foto, fileName);
      return formData;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<void> deleteFoto(String foto) async {
    try {
      await produtoRepository.deleteFoto(foto);
    } catch (e) {
      error = e;
    }
  }

  @action
  void addCores(Cor cor) {
    try {
      coresSelecionada.add(cor);
    } catch (e) {
      error = e;
    }
  }

  @action
  void addTamanhos(Tamanho tamanho) {
    try {
      tamanhosSelecionada.add(tamanho);
    } catch (e) {
      error = e;
    }
  }

  @action
  void removerCores(Cor cor) {
    try {
      coresSelecionada.remove(cor);
    } catch (e) {
      error = e;
    }
  }

  @action
  void removerTamanhos(Tamanho tamanho) {
    try {
      tamanhosSelecionada.remove(tamanho);
    } catch (e) {
      error = e;
    }
  }
}
