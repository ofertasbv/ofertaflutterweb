import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/promocao.dart';
import 'package:nosso/src/core/repository/promocao_repository.dart';

part 'promocao_controller.g.dart';

class PromoCaoController = PromoCaoControllerBase with _$PromoCaoController;

abstract class PromoCaoControllerBase with Store {
  PromocaoRepository promocaoRepository;

  PromoCaoControllerBase() {
    promocaoRepository = PromocaoRepository();
  }

  @observable
  List<Promocao> promocoes;

  @observable
  int promocao;

  @observable
  FormData formData;

  @observable
  Exception error;

  @observable
  DioError dioError;

  @observable
  String mensagem;

  @action
  Future<List<Promocao>> getAll() async {
    try {
      promocoes = await promocaoRepository.getAll();
      return promocoes;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Promocao p) async {
    try {
      promocao = await promocaoRepository.create(p.toJson());
      if (promocao == null) {
        mensagem = "sem dados";
      } else {
        return promocao;
      }
    } on DioError catch (e) {
      mensagem = e.message;
      dioError = e;
    }
  }

  @action
  Future<int> update(int id, Promocao p) async {
    try {
      promocao = await promocaoRepository.update(id, p.toJson());
      return promocao;
    } on DioError catch (e) {
      mensagem = e.message;
      dioError = e;
    }
  }

  @action
  Future<FormData> upload(File foto, String fileName) async {
    try {
      formData = await promocaoRepository.upload(foto, fileName);
      return formData;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<void> deleteFoto(String foto) async {
    try {
      await promocaoRepository.deleteFoto(foto);
    } catch (e) {
      error = e;
    }
  }
}
