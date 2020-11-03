import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/cliente.dart';
import 'package:nosso/src/core/repository/cliente_repository.dart';

part 'cliente_controller.g.dart';

class ClienteController = ClienteControllerBase with _$ClienteController;

abstract class ClienteControllerBase with Store {
  ClienteRepository _clienteRepository;

  ClienteControllerBase() {
    _clienteRepository = ClienteRepository();
  }

  @observable
  List<Cliente> clientes;

  @observable
  int cliente;

  @observable
  Exception error;

  @observable
  FormData formData;

  @observable
  bool senhaVisivel = false;

  @action
  visualizarSenha() {
    senhaVisivel = !senhaVisivel;
  }

  @action
  Future<List<Cliente>> getAll() async {
    try {
      clientes = await _clienteRepository.getAll();
      return clientes;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Cliente p) async {
    try {
      cliente = await _clienteRepository.create(p.toJson());
      return cliente;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> update(int id, Cliente p) async {
    try {
      cliente = await _clienteRepository.update(id, p.toJson());
      return cliente;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<FormData> upload(File foto, String fileName) async {
    try {
      formData = await _clienteRepository.upload(foto, fileName);
      return formData;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<void> deleteFoto(String foto) async {
    try {
      await _clienteRepository.deleteFoto(foto);
    } catch (e) {
      error = e;
    }
  }
}
