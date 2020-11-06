import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:nosso/src/api/custon_dio.dart';
import 'package:nosso/src/core/model/arquivo.dart';
import 'package:nosso/src/core/repository/arquivo_repository.dart';

part 'arquivo_controller.g.dart';

class ArquivoController = ArquivoControllerBase with _$ArquivoController;

abstract class ArquivoControllerBase with Store {
  ArquivoRepository arquivoRepository;

  CustonDio custonDio;

  ArquivoControllerBase() {
    custonDio = CustonDio();
    arquivoRepository = ArquivoRepository();
  }

  @observable
  List<Arquivo> arquivos;

  @observable
  int arquivo;

  @observable
  FormData formData;

  @observable
  Exception error;

  @observable
  DioError dioError;

  @action
  Future<List<Arquivo>> getAll() async {
    try {
      arquivos = await arquivoRepository.getAll();
      return arquivos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Arquivo p) async {
    try {
      arquivo = await arquivoRepository.create(p.toJson());
      if (arquivo == null) {
        mensagem = "sem dados - null";
      } else if (arquivo == 400) {
        mensagem = "olá mobx em flutter - 400";
      } else if (arquivo == 404) {
        mensagem = "olá mobx em flutter - 400";
      } else if (arquivo == 500) {
        mensagem = "olá mobx em flutter - 500";
      } else {
        return arquivo;
      }
    } on DioError catch (e) {
      mensagem = e.message;
      dioError = e;
    }
  }

  @action
  Future<int> update(int id, Arquivo p) async {
    try {
      arquivo = await arquivoRepository.update(id, p.toJson());
      return arquivo;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<FormData> upload(File foto, String fileName) async {
    try {
      formData = await arquivoRepository.upload(foto, fileName);
      return formData;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<void> deleteFoto(String foto) async {
    try {
      await arquivoRepository.deleteFoto(foto);
    } catch (e) {
      error = e;
    }
  }

  @observable
  String mensagem;

  @action
  teste() {
    try {
      mensagem = "olá mobx em flutter - acerto";
    } catch (e) {
      mensagem = "olá mobx em flutter - error";
    }
  }
}
