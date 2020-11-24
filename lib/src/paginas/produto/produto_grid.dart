import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/paginas/produto/produto_create_page.dart';
import 'package:nosso/src/paginas/produto/produto_detalhes_tab.dart';
import 'package:nosso/src/util/filter/produto_filter.dart';
import 'package:nosso/src/util/load/circular_progresso.dart';

class ProdutoGrid extends StatefulWidget {
  ProdutoFilter filter;

  ProdutoGrid({Key key, this.filter}) : super(key: key);

  @override
  _ProdutoGridState createState() => _ProdutoGridState(filter: this.filter);
}

class _ProdutoGridState extends State<ProdutoGrid>
    with AutomaticKeepAliveClientMixin<ProdutoGrid> {
  _ProdutoGridState({this.filter});

  var produtoController = GetIt.I.get<ProdutoController>();

  final formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

  ProdutoFilter filter;

  bool isFavorito = false;

  @override
  void initState() {
    if (filter != null) {
      produtoController.getFilter(filter);
    } else {
      produtoController.getAll();
    }
    super.initState();
  }

  Future<void> onRefresh() {
    return produtoController.getAll();
  }

  favoritar(Produto p) {
    p.favorito = !p.favorito;
    print("${p.favorito}");
  }

  showDialogAlert(BuildContext context, Produto p) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('INFORMAÇÃOES'),
          content: Text(p.nome),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('EDITAR'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProdutoCreatePage(
                        produto: p,
                      );
                    },
                  ),
                );
              },
            ),
            FlatButton(
              child: const Text('VER DETALHES'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProdutoDetalhesTab(p);
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Produto> produtos = produtoController.produtos;
          if (produtoController.error != null) {
            return Text("Não foi possível buscar produtos");
          }

          if (produtos == null) {
            return CircularProgressor();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderGrid(produtos),
          );
        },
      ),
    );
  }

  builderGrid(List<Produto> produtos) {
    return GridView.builder(
      padding: EdgeInsets.only(top: 5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 0.7,
      ),
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];
        return GestureDetector(
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(00),
            ),
            duration: Duration(seconds: 2),
            curve: Curves.bounceIn,
            child: Column(
              children: <Widget>[
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.white,
                  child: Image.network(
                    produtoController.arquivo + p.foto,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        p.nome,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "R\$ ${p.estoque.valor}",
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                          CircleAvatar(
                            foregroundColor: Colors.redAccent,
                            backgroundColor: Colors.grey[300],
                            radius: 15,
                            child: IconButton(
                              splashColor: Colors.black,
                              icon: (p.favorito == false
                                  ? Icon(
                                      Icons.favorite_border,
                                      color: Colors.redAccent,
                                      size: 15,
                                    )
                                  : Icon(
                                      Icons.favorite_outlined,
                                      color: Colors.redAccent,
                                      size: 15,
                                    )),
                              onPressed: () {
                                setState(() {
                                  print("Favoritar: ${p.nome}");
                                  favoritar(p);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
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
