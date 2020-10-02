import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/loja_controller.dart';
import 'package:nosso/src/paginas/loja/loja_list.dart';
import 'package:nosso/src/paginas/produto/produto_search.dart';

class LojaPage extends StatelessWidget {
  LojaController lojaController = GetIt.I.get<LojaController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lojas"),
        actions: <Widget>[
          Observer(
            builder: (context) {
              if (lojaController.error != null) {
                return Text("Não foi possível carregar");
              }

              if (lojaController.lojas == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Chip(
                label: Text(
                  (lojaController.lojas.length ?? 0).toString(),
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
              );
            },
          ),
          SizedBox(width: 20),
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              size: 30,
            ),
            onPressed: () {
              showSearch(context: context, delegate: ProdutoSearchDelegate());
            },
          )
        ],
      ),
      body: LojaList(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 8,
            height: 8,
          ),
          FloatingActionButton(
            elevation: 10,
            child: Icon(Icons.add),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => LojaCreatePage(),
              //   ),
              // );
            },
          )
        ],
      ),
    );
  }
}
