

import 'package:nosso/src/core/model/endereco.dart';
import 'package:nosso/src/core/model/usuario.dart';

class Cliente {
  int id;
  String nome;
  String telefone;
  bool ativo;
  String tipoPessoa;
  String dataRegistro;
  String foto;
  Usuario usuario;
  List<Endereco> enderecos;
  String cpf;
  String sexo;
  bool novo;
  bool existente;

  Cliente(
      {this.id,
        this.nome,
        this.telefone,
        this.ativo,
        this.tipoPessoa,
        this.dataRegistro,
        this.foto,
        this.usuario,
        this.enderecos,
        this.cpf,
        this.sexo,
        this.novo,
        this.existente});

  Cliente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    telefone = json['telefone'];
    ativo = json['ativo'];
    tipoPessoa = json['tipoPessoa'];
    dataRegistro = json['dataRegistro'];
    foto = json['foto'];
    usuario =
    json['usuario'] != null ? new Usuario.fromJson(json['usuario']) : null;
    if (json['enderecos'] != null) {
      enderecos = new List<Null>();
      json['enderecos'].forEach((v) {
        enderecos.add(new Endereco.fromJson(v));
      });
    }
    cpf = json['cpf'];
    sexo = json['sexo'];
    novo = json['novo'];
    existente = json['existente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    data['ativo'] = this.ativo;
    data['tipoPessoa'] = this.tipoPessoa;
    data['dataRegistro'] = this.dataRegistro;
    data['foto'] = this.foto;
    if (this.usuario != null) {
      data['usuario'] = this.usuario.toJson();
    }
    if (this.enderecos != null) {
      data['enderecos'] = this.enderecos.map((v) => v.toJson()).toList();
    }
    data['cpf'] = this.cpf;
    data['sexo'] = this.sexo;
    data['novo'] = this.novo;
    data['existente'] = this.existente;
    return data;
  }
}
