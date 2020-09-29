import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/paginas/produto/produto_detalhes.dart';


class ProdutoList extends StatefulWidget {
  @override
  _ProdutoListState createState() => _ProdutoListState();
}

class _ProdutoListState extends State<ProdutoList> {
  final produtoController = GetIt.I.get<ProdutoController>();

  @override
  void initState() {
    produtoController.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        List<Produto> produtos = produtoController.produtos;
        if (produtoController.error != null) {
          return Text("Não foi possível buscar produtos");
        }

        if (produtos == null) {
          return Center(child: CircularProgressIndicator());
        }

        return builderGrid(produtos);
      },
    );
  }

  builderGrid(List<Produto> produtos) {
    return GridView.builder(
      padding: EdgeInsets.only(bottom: 20),
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];
        return GestureDetector(
          child: AnimatedContainer(
            width: 100,
            height: 700,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(00),
              border: Border.all(
                color: Colors.black12,
                width: 1,
              ),
            ),
            duration: Duration(seconds: 2),
            curve: Curves.bounceIn,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.transparent,
                  child: Image.network(
                    ConstantApi.urlArquivoProduto + p.foto,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              p.nome,
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "R\$ ${p.estoque.valor}",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProdutoDetalhes();
                },
              ),
            );
            print("produto:  ${p.nome}");
          },
        );
      },
    );
  }

  ListView builderList(List<Produto> produtos) {
    double containerWidth = 160;
    double containerHeight = 30;

    return ListView.builder(
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];

        return GestureDetector(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  //color: Colors.grey[200],
                  margin: EdgeInsets.symmetric(vertical: 7.5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          ConstantApi.urlArquivoProduto + p.foto,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Container(
                        width: containerWidth,
                        //color: Colors.grey[200],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: containerHeight,
                              width: containerWidth,
                              //color: Colors.grey[300],
                              child: Text(
                                p.nome,
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: containerHeight,
                              width: containerWidth,
                              //color: Colors.grey[300],
                              child: Text(
                                p.descricao,
                              ),
                            ),
                            Container(
                              height: 20,
                              width: containerWidth * 0.75,
                              //color: Colors.grey[300],
                              child: Text(
                                "R\$ ${p.estoque.valor}",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 50,
                        //color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          ),
          onTap: () {},
        );
      },
    );
  }
}
