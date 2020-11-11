import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/cor.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/core/model/marca.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/core/model/promocao.dart';
import 'package:nosso/src/core/model/subcategoria.dart';
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
  FormData formData;

  @observable
  Exception error;

  @observable
  DioError dioError;

  @observable
  String mensagem;

  @observable
  Marca marcaSelecionada;

  @observable
  SubCategoria subCategoriaSelecionada;

  @observable
  Loja lojaSelecionada;

  @observable
  Promocao promocaoSelecionada;

  @observable
  ObservableList<Cor> coresSelecionada;

  @observable
  ObservableList<Tamanho> tamanhosSelecionada;

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
      produtoSelecionado =
          await produtoRepository.getProdutoByCodBarra(codBarra);
      return produtoSelecionado;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Produto p) async {
    try {
      p.marca = marcaSelecionada;
      p.subCategoria = subCategoriaSelecionada;
      p.loja = lojaSelecionada;
      p.promocao = promocaoSelecionada;

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
      p.marca = marcaSelecionada;
      p.subCategoria = subCategoriaSelecionada;
      p.loja = lojaSelecionada;
      p.promocao = promocaoSelecionada;

      produto = await produtoRepository.update(id, p.toJson());
      return produto;
    } on DioError catch (e) {
      mensagem = e.message;
      dioError = e;
    }
  }

  @action
  Future<FormData> upload(File foto, String fileName) async {
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
}
