import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/paginas/produto/produto_create_page.dart';
import 'package:nosso/src/paginas/produto/produto_grid.dart';
import 'package:nosso/src/paginas/produto/produto_list.dart';
import 'package:nosso/src/paginas/produto/produto_search.dart';
import 'package:nosso/src/util/filter/produto_filter.dart';

class ProdutoTab extends StatefulWidget {
  ProdutoFilter filter;

  ProdutoTab({Key key, this.filter}) : super(key: key);

  @override
  _ProdutoTabState createState() => _ProdutoTabState(filter: this.filter);
}

class _ProdutoTabState extends State<ProdutoTab> {
  _ProdutoTabState({this.filter});

  var produtoController = GetIt.I.get<ProdutoController>();

  ProdutoFilter filter;
  bool destaque = false;

  @override
  void initState() {
    if (filter == null) {
      filter = ProdutoFilter();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    filter.destaque = true;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
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

                return CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.indigo[900],
                  child: Text(
                    (produtoController.produtos.length ?? 0).toString(),
                    style: TextStyle(color: Colors.yellow[900]),
                  ),
                );
              },
            ),
            SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.indigo[900],
              child: IconButton(
                icon: Icon(
                  Icons.tune,
                ),
                onPressed: () {
                  showDialogAlert(context);
                },
              ),
            ),
            SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.indigo[900],
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.search,
                ),
                onPressed: () {
                  showSearch(
                      context: context, delegate: ProdutoSearchDelegate());
                },
              ),
            ),
            SizedBox(width: 10),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.view_column,
                  size: 30,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.list,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            ProdutoGrid(),
            ProdutoList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProdutoCreatePage()),
            );
          },
        ),
      ),
    );
  }

  verificar() {
    destaque = !destaque;
  }

  showDialogAlert(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Filtro de pesquisa"),
              content: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(0),
                    color: Colors.white,
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Checkbox(
                            value: destaque,
                            onChanged: (bool value) {
                              setState(() {
                                destaque = value;
                                filter.destaque = destaque;
                                print("Filter destaque: ${filter.destaque}");
                              });
                            },
                          ),
                        ),
                        Center(
                          child: Text("Destaque"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                RaisedButton.icon(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                  ),
                  label: Text('CANCELAR'),
                  color: Colors.grey,
                  elevation: 0,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton.icon(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.yellow[900]),
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                  ),
                  label: Text('APLICAR'),
                  color: Colors.yellow[900],
                  elevation: 0,
                  onPressed: () {
                    produtoController.getFilter(filter);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
