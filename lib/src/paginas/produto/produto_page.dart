import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/pedidoItem_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/core/model/promocao.dart';
import 'package:nosso/src/core/model/subcategoria.dart';
import 'package:nosso/src/paginas/produto/drawer_filter.dart';
import 'package:nosso/src/paginas/produto/produto_create_page.dart';
import 'package:nosso/src/paginas/produto/produto_list.dart';
import 'package:nosso/src/paginas/produto/produto_search.dart';
import 'package:nosso/src/util/filter/produto_filter.dart';

class ProdutoPage extends StatefulWidget {
  Promocao p;
  SubCategoria s;
  Produto pd;
  String nome;
  ProdutoFilter filter;

  ProdutoPage({Key key, this.p, this.s, this.pd, this.nome, this.filter})
      : super(key: key);

  @override
  _ProdutoPageState createState() => _ProdutoPageState(
        p: this.p,
        s: this.s,
        pd: this.pd,
        nome: this.nome,
        filter: this.filter,
      );
}

class _ProdutoPageState extends State<ProdutoPage>
    with SingleTickerProviderStateMixin {
  ProdutoController produtoController = GetIt.I.get<ProdutoController>();
  final pedidoItemController = GetIt.I.get<PedidoItemController>();

  Promocao p;
  SubCategoria s;
  Produto pd;
  String nome;
  ProdutoFilter filter;

  _ProdutoPageState({this.p, this.s, this.pd, this.nome, this.filter});

  AnimationController animationController;
  Animation<double> animation;
  static final _scaleTween = Tween<double>(begin: 1.0, end: 1.5);

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceInOut,
    );

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos"),
        actions: <Widget>[
          Observer(
            builder: (context) {
              if (produtoController.error != null) {
                return Text("Não foi possível carregar");
              }

              if (produtoController.produtos == null) {
                return Center(
                  child: Icon(Icons.warning_amber_outlined),
                );
              }

              return Chip(
                label: Text(
                  (produtoController.produtos.length ?? 0).toString(),
                ),
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ProdutoList(),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return ProdutoCreatePage();
            }),
          );
        },
      ),
    );
  }
}
