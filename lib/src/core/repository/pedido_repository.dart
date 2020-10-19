import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/api/custon_dio.dart';
import 'package:nosso/src/core/model/pedido.dart';

class PedidoRepository {
  CustonDio dio = CustonDio();

  Future<List<Pedido>> getAllById(int id) async {
    try {
      print("carregando pedidos by id");
      var response = await dio.client.get("/pedidos/${id}");
      return (response.data as List)
          .map((c) => Pedido.fromJson(c))
          .toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Pedido>> getAll() async {
    try {
      print("carregando pedidos");
      var response = await dio.client.get("/pedidos");
      return (response.data as List)
          .map((c) => Pedido.fromJson(c))
          .toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post("/pedidos/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(int id, Map<String, dynamic> data) async {
    try {
      var response = await dio.client.put("/pedidos/update/$id", data: data);
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

    var response = await Dio()
        .post(ConstantApi.urlList + "/pedidos/upload", data: formData);
    print("RESPONSE: $response");
    print("fileDir: $fileDir");
    return formData;
  }
}
