import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/paginas/produto/produto_detalhes_tab.dart';

class ProdutoListHome extends StatefulWidget {
  @override
  _ProdutoListHomeState createState() => _ProdutoListHomeState();
}

class _ProdutoListHomeState extends State<ProdutoListHome>
    with AutomaticKeepAliveClientMixin<ProdutoListHome> {
  ProdutoController produtoController = GetIt.I.get<ProdutoController>();

  @override
  void initState() {
    produtoController.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return produtoController.getAll();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return builderConteudoList();
  }

  builderConteudoList() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Produto> produtos = produtoController.produtos;
          if (produtoController.error != null) {
            return Text("Não foi possível buscar produtos");
          }

          if (produtos == null) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(produtos),
          );
        },
      ),
    );
  }

  ListView builderList(List<Produto> produtos) {
    double containerWidth = 200;
    double containerHeight = 20;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];

        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: AnimatedContainer(
              duration: Duration(seconds: 2),
              margin: EdgeInsets.symmetric(vertical: 7.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    color: Colors.grey[200],
                    child: Image.network(
                      ConstantApi.urlArquivoProduto + p.foto,
                      fit: BoxFit.cover,
                      width: 110,
                      height: 110,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.grey[100],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: containerHeight,
                          width: containerWidth,
                          child: Text(p.nome),
                        ),
                        SizedBox(height: 5),
                        Container(
                          height: containerHeight,
                          width: containerWidth,
                          child: Text(p.descricao),
                        ),
                        SizedBox(height: 5),
                        Container(
                          height: containerHeight,
                          width: containerWidth,
                          //color: Colors.grey[300],
                          child: Text(
                            p.loja != null ? (p.loja.nome) : "sem loja",
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          height: containerHeight,
                          width: containerWidth * 0.75,
                          //color: Colors.grey[300],
                          child: Text(
                            "R\$ ${p.estoque.valor}",
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProdutoDetalhesTab(p);
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
