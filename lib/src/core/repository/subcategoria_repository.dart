import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/api/custon_dio.dart';
import 'package:nosso/src/core/model/subcategoria.dart';

class SubCategoriaRepository {
  CustonDio dio = CustonDio();

  Future<List<SubCategoria>> getAllById(int id) async {
    try {
      print("carregando subcategorias by id");
      var response = await dio.client.get("/produtos/${id}");
      return (response.data as List)
          .map((c) => SubCategoria.fromJson(c))
          .toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<SubCategoria>> getAll() async {
    try {
      print("carregando subcategorias");
      var response = await dio.client.get("/subcategorias");
      return (response.data as List)
          .map((c) => SubCategoria.fromJson(c))
          .toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<SubCategoria>> getAllByCategoriaById(int id) async {
    try {
      print("carregando subcategorias da categoria");
      var response = await dio.client.get("/subcategorias/categoria/$id");
      return (response.data as List)
          .map((c) => SubCategoria.fromJson(c))
          .toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post("/subcategorias/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      var response = await dio.client.patch("/subcategorias/update/$id", data: data);
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
        .post(ConstantApi.urlList + "/subcategorias/upload", data: formData);
    print("RESPONSE: $response");
    print("fileDir: $fileDir");
    return formData;
  }
}
