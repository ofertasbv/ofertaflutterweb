import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/api/custon_dio.dart';
import 'package:nosso/src/core/model/promocao.dart';

class PromocaoRepository {
  CustonDio dio = CustonDio();

  Future<List<Promocao>> getAll() async {
    try {
      print("carregando promoções");
      var response = await dio.client.get("/promocoes");
      return (response.data as List).map((c) => Promocao.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Promocao>> getAllById(int id) async {
    try {
      print("carregando promoções by id");
      var response = await dio.client.get("/promocoes/${id}");
      return (response.data as List).map((c) => Promocao.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post("/promocoes/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      var response =
          await dio.client.patch("/promocoes/update/$id", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  static Future<FormData> upload(File file, String fileName) async {
    var fileDir = file.path;
    var paramentros = {
      "foto": await MultipartFile.fromFile(fileDir, filename: fileName)
    };
    FormData formData = FormData.fromMap(paramentros);
    var response = await Dio()
        .post(ConstantApi.urlList + "/promocoes/upload", data: formData);
    print("RESPONSE: $response");
    print("fileDir: $fileDir");
    return formData;
  }
}
