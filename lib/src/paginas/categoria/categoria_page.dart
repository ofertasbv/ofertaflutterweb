import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/categoria_controller.dart';
import 'package:nosso/src/paginas/categoria/categoria_create_page.dart';
import 'package:nosso/src/paginas/categoria/categoria_list.dart';
import 'package:nosso/src/paginas/produto/produto_search.dart';

class CategoriaPage extends StatelessWidget {
  CategoriaController categoriaController = GetIt.I.get<CategoriaController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
        actions: <Widget>[
          Observer(
            builder: (context) {
              if (categoriaController.error != null) {
                return Text("Não foi possível carregar");
              }

              if (categoriaController.categorias == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Chip(
                label: Text(
                  (categoriaController.categorias.length ?? 0).toString(),
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
      body: CategoriaList(),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CategoriaCreatePage();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
