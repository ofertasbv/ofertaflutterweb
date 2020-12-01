import 'package:dio/dio.dart';
import 'package:nosso/src/api/custon_dio.dart';
import 'package:nosso/src/core/model/usuario.dart';

class UsuarioRepository {
  CustonDio dio = CustonDio();

  Future<List<Usuario>> getAllById(int id) async {
    try {
      print("carregando usuarios by id");
      var response = await dio.client.get("/usuarios/${id}");
      return (response.data as List).map((c) => Usuario.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Usuario>> getAll() async {
    try {
      print("carregando usuarios");
      var response = await dio.client.get("/usuarios");
      return (response.data as List).map((c) => Usuario.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<Usuario> getByEmail(String email) async {
    try {
      print("carregando usuarios by email");
      var response = await dio.client.get("/usuarios/email/$email");
      return Usuario.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<Usuario> getByLogin(String email, String senha) async {
    try {
      print("carregando usuario by login");
      var response = await dio.client.get("/usuarios/login/$email/$senha");
      return Usuario.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    var response = await dio.client.post("/usuarios/create", data: data);
    return response.statusCode;
  }

  Future<int> update(int id, Map<String, dynamic> data) async {
    var response = await dio.client.put("/usuarios/update/$id", data: data);
    return response.statusCode;
  }
}
