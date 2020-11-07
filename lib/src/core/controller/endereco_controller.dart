import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:nosso/src/api/custon_dio.dart';
import 'package:nosso/src/core/model/endereco.dart';
import 'package:nosso/src/core/repository/endereco_repository.dart';

part 'endereco_controller.g.dart';

class EnderecoController = EnderecoControllerBase with _$EnderecoController;

abstract class EnderecoControllerBase with Store {
  EnderecoRepository enderecoRepository;

  EnderecoControllerBase() {
    enderecoRepository = EnderecoRepository();
  }

  @observable
  List<Endereco> enderecos;

  @observable
  int endereco;

  @observable
  Exception error;

  @observable
  DioError dioError;

  @observable
  String mensagem;

  @action
  Future<List<Endereco>> getAll() async {
    try {
      enderecos = await enderecoRepository.getAll();
      return enderecos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Endereco p) async {
    try {
      endereco = await enderecoRepository.create(p.toJson());
      if (endereco == null) {
        mensagem = "sem dados";
      } else {
        return endereco;
      }
    } on DioError catch (e) {
      mensagem = e.message;
      dioError = e;
    }
  }

  @action
  Future<int> update(int id, Endereco p) async {
    try {
      endereco = await enderecoRepository.update(id, p.toJson());
      return endereco;
    } on DioError catch (e) {
      mensagem = e.message;
      dioError = e;
    }
  }
}
