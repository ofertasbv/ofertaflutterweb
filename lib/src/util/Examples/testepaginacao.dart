import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:nosso/src/core/model/pageable.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/core/model/produtopage.dart';
import 'package:nosso/src/core/model/produtoprincipal.dart';
import 'package:nosso/src/core/model/testepagina.dart';
import 'package:nosso/src/core/repository/produto_repository.dart';
import 'package:nosso/src/util/Examples/photo.dart';

class MainFetchData extends StatefulWidget {
  @override
  _MainFetchDataState createState() => _MainFetchDataState();
}

class _MainFetchDataState extends State<MainFetchData> {
  ProdutoRepository produtoRepository = ProdutoRepository();
  List<ProdutoPrincipal> list = List();
  List<ProdutoData> produtos = List();
  var isLoading = false;

  // _fetchData() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final response =
  //       await http.get("https://jsonplaceholder.typicode.com/photos");
  //   if (response.statusCode == 200) {
  //     list = (json.decode(response.body) as List)
  //         .map((data) => new Photo.fromJson(data))
  //         .toList();
  //     setState(() {
  //       isLoading = false;
  //     });
  //   } else {
  //     throw Exception('Failed to load photos');
  //   }
  // }

  List<Produto> fabios = List<Produto>();

  String url = "api.fabio.com";

  Future<Produto> nextPageFabio() async {
    try {
      var response = await http.get(url);
      var json = jsonDecode(response.body);
      return Produto.fromJson(json);
    } on Exception catch (error) {
      print(error);
      return null;
    }
  }

  fetchData1() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get("http://10.0.0.107:8081/produtos");
    if (response.statusCode == 200) {
      produtos =
          (json.decode(response.body)).map((p) => new ProdutoData.fromJson(p));
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  parsePosts() async {
    final response = await http.get("http://10.0.0.107:8081/produtos");
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<Produto>((json) => Produto.fromJson(json)).toList();
  }

  fetchPosts() async {
    http.Response response = await http.get("http://10.0.0.107:8081/produtos");
    // print("${response.body}");
    var responseJson = json.decode(response.body);
    print("${responseJson}");
    list = responseJson.map((m) => new ProdutoPrincipal.fromJson(m)).toList();
    return list;
  }

  Future<ProdutoPrincipal> fetchInfo() async {
    http.Response response = await http.get("http://10.0.0.107:8081/produtos");
    var jsonresponse = json.decode(response.body);
    print("${jsonresponse}");

    return ProdutoPrincipal.fromJson(jsonresponse);
  }

  // Future<List<ProdutoPrincipal>> getProductList() async {
  //   list = await produtoRepository.getAllPageable();
  //   return list.cast();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fetch Data JSON"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          child: Text("Fetch Data"),
          onPressed: fetchPosts,
        ),
      ),
      // body: isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : ListView.builder(
      //         itemCount: produtos.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           return ListTile(
      //             contentPadding: EdgeInsets.all(10.0),
      //             title: Text("produtos[index]"),
      //           );
      //         },
      //       ),
    );
  }
}
