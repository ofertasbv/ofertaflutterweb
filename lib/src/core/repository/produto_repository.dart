import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/api/custon_dio.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/util/filter/produto_filter.dart';

class ProdutoRepository {
  CustonDio dio = CustonDio();

  Future<List<Produto>> getAllById(int id) async {
    try {
      print("carregando produtos by id");
      var response = await dio.client.get("/produtos/${id}");
      print("resposta: ${response}");
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

  Future<List<Produto>> getFilter(ProdutoFilter filter) async {
    try {
      print("carregando produtos filtrados");
      var response = await dio.client.get("/produtos/filter?$filter");
      return (response.data as List).map((c) => Produto.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Produto>> getAllBySubCategoriaById(int id) async {
    try {
      print("carregando produtos da subcategoria");
      var response = await dio.client.get("/produtos/subcategoria/$id");
      return (response.data as List).map((c) => Produto.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<Produto> getProdutoByCodBarra(String codigoBarra) async {
    try {
      print("carregando produtos by codigo de barra");
      var response = await dio.client.get("/produtos/codigobarra/$codigoBarra");
      return Produto.fromJson(response.data);
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
      var response = await dio.client.patch("/produtos/update/$id", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  static Future<FormData> upload(File file, String fileName) async {
    var arquivo = file.path;
    var fileDir = file.path;

    var paramentros = {
      "foto": await MultipartFile.fromFile(fileDir, filename: fileName)
    };

    FormData formData = FormData.fromMap(paramentros);

    var response = await Dio()
        .post(ConstantApi.urlList + "/produtos/upload", data: formData);
    print("RESPONSE: $response");
    print("fileDir: $fileDir");
    return formData;
  }
}
