
import 'package:mobx/mobx.dart';
import 'package:nosso/src/core/model/endereco.dart';
import 'package:nosso/src/core/repository/endereco_repository.dart';

part 'endereco_controller.g.dart';

class EnderecoController = EnderecoControllerBase with _$EnderecoController;
abstract class EnderecoControllerBase with Store{
  EnderecoRepository _enderecoRepository;

  EnderecoControllerBase() {
    _enderecoRepository = EnderecoRepository();
  }

  @observable
  List<Endereco> enderecos;

  @observable
  int endereco;

  @observable
  Exception error;

  @action
  Future<List<Endereco>> getAll() async {
    try {
      enderecos = await _enderecoRepository.getAll();
      return enderecos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Endereco p) async {
    try {
      endereco = await _enderecoRepository.create(p.toJson());
      return endereco;
    } catch (e) {
      error = e;
    }
  }
}