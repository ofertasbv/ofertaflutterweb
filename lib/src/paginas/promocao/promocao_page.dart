import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/promocao_controller.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/paginas/produto/produto_search.dart';
import 'promocao_list.dart';

class PromocaoPage extends StatefulWidget {
  Loja p;

  PromocaoPage({Key key, this.p}) : super(key: key);

  @override
  _PromocaoPageState createState() => _PromocaoPageState(p: this.p);
}

class _PromocaoPageState extends State<PromocaoPage> {
  PromoCaoController promocaoController = GetIt.I.get<PromoCaoController>();

  Loja p;

  _PromocaoPageState({this.p});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ofertas"),
        actions: <Widget>[
          Observer(
            builder: (context) {
              if (promocaoController.error != null) {
                return Text("Não foi possível carregar");
              }

              if (promocaoController.promocoes == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Chip(
                label: Text(
                  (promocaoController.promocoes.length ?? 0).toString(),
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
          ),
        ],
      ),
      body: PromocaoList(p: p),
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
              //   MaterialPageRoute(builder: (context) => PromocaoCreatePage()),
              // );
            },
          )
        ],
      ),
    );
  }
}
