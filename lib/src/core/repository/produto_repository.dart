
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/api/custon_dio.dart';
import 'package:nosso/src/core/model/produto.dart';

class ProdutoRepository {
  CustonDio dio = CustonDio();

  Future<List<Produto>> getAllById(int id) async {
    try {
      print("carregando produtos by id");
      var response = await dio.client.get("/produtos/${id}");
      return (response.data as List).map((c) => Produto.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }


  Future<List<Produto>> getAll() async {
    try {
      print("carregando produtos");
      var response = await dio.client.get("/produtos/pesquisa");
      return (response.data as List).map((c) => Produto.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post("/produtos/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      var response = await dio.client.patch("/produtos/$id", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  static Future<FormData> upload(File file, String fileName) async {
    var arquivo = file.path;
    var fileDir = file.path;

    var paramentros = {
      "file": await MultipartFile.fromFile(fileDir, filename: fileName)
    };

    FormData formData = FormData.fromMap(paramentros);

    var response = await Dio().post(ConstantApi.urlList + "/produtos/upload", data: formData);
    print("RESPONSE: $response");
    print("fileDir: $fileDir");
    return formData;
  }
}