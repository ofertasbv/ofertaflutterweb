import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:nosso/src/api/custon_dio.dart';
import 'package:nosso/src/core/model/categoria.dart';
import 'package:nosso/src/core/repository/categoria_repository.dart';

part 'categoria_controller.g.dart';

class CategoriaController = CategoriaControllerBase with _$CategoriaController;

abstract class CategoriaControllerBase with Store {
  CategoriaRepository categoriaRepository;

  CategoriaControllerBase() {
    categoriaRepository = CategoriaRepository();
  }

  @observable
  List<Categoria> categorias;

  @observable
  int categoria;

  @observable
  FormData formData;

  @observable
  Exception error;

  @observable
  DioError dioError;

  @observable
  String mensagem;

  @action
  Future<List<Categoria>> getAll() async {
    try {
      categorias = await categoriaRepository.getAll();
      return categorias;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Categoria p) async {
    try {
      categoria = await categoriaRepository.create(p.toJson());
      if (categoria == null) {
        mensagem = "sem dados";
      } else {
        return categoria;
      }
    } on DioError catch (e) {
      mensagem = e.message;
      dioError = e;
    }
  }

  @action
  Future<int> update(int id, Categoria p) async {
    try {
      categoria = await categoriaRepository.update(id, p.toJson());
      return categoria;
    } on DioError catch (e) {
      mensagem = e.message;
      dioError = e;
    }
  }

  @action
  Future<FormData> upload(File foto, String fileName) async {
    try {
      formData = await categoriaRepository.upload(foto, fileName);
      return formData;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<void> deleteFoto(String foto) async {
    try {
      await categoriaRepository.deleteFoto(foto);
    } catch (e) {
      error = e;
    }
  }
}
