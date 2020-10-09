import 'package:nosso/src/core/model/endereco.dart';
import 'package:nosso/src/core/model/usuario.dart';

class Cliente {
  int id;
  String nome;
  String telefone;
  bool ativo;
  String tipoPessoa;
  DateTime dataRegistro;
  String foto;
  Usuario usuario = new Usuario();
  Endereco endereco = new Endereco();
  String cpf;
  String sexo;

  Cliente(
      {this.id,
      this.nome,
      this.telefone,
      this.ativo,
      this.tipoPessoa,
      this.dataRegistro,
      this.foto,
      this.usuario,
      this.endereco,
      this.cpf,
      this.sexo});

  Cliente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    telefone = json['telefone'];
    ativo = json['ativo'];
    tipoPessoa = json['tipoPessoa'];
    dataRegistro = DateTime.tryParse(json['dataRegistro'].toString());
    foto = json['foto'];
    usuario =
        json['usuario'] != null ? new Usuario.fromJson(json['usuario']) : null;

    endereco = json['endereco'] != null
        ? new Endereco.fromJson(json['endereco'])
        : null;

    cpf = json['cpf'];
    sexo = json['sexo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    data['ativo'] = this.ativo;
    data['tipoPessoa'] = this.tipoPessoa;
    data['dataRegistro'] = this.dataRegistro.toIso8601String();
    data['foto'] = this.foto;
    if (this.usuario != null) {
      data['usuario'] = this.usuario.toJson();
    }
    if (this.endereco != null) {
      data['endereco'] = this.endereco.toJson();
    }
    data['cpf'] = this.cpf;
    data['sexo'] = this.sexo;
    return data;
  }
}
