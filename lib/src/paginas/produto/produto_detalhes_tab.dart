import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/pedidoItem_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/paginas/produto/produto_detalhes_info.dart';
import 'package:nosso/src/paginas/produto/produto_detalhes_view.dart';
import 'package:nosso/src/paginas/produto/produto_page.dart';
import 'package:nosso/src/paginas/produto/produto_search.dart';

class ProdutoDetalhesTab extends StatefulWidget {
  Produto p;

  ProdutoDetalhesTab(this.p);

  @override
  _ProdutoDetalhesTabState createState() => _ProdutoDetalhesTabState();
}

class _ProdutoDetalhesTabState extends State<ProdutoDetalhesTab>
    with SingleTickerProviderStateMixin {
  ProdutoController produtoController = GetIt.I.get<ProdutoController>();
  final pedidoItemController = GetIt.I.get<PedidoItemController>();

  AnimationController animationController;
  Animation<double> animation;
  static final _scaleTween = Tween<double>(begin: 1.0, end: 1.5);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFavorito = false;

  Produto produto;
  var text = "";

  @override
  void initState() {
    if (produto == null) {
      produto = Produto();
    }
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
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  void showDefaultSnackbar(BuildContext context, String content) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    produto = widget.p;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Detalhes"),
          actions: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.orange[900],
              child: IconButton(
                icon: Icon(Icons.search_outlined),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ProdutoSearchDelegate(),
                  );
                },
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.orange[900],
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 0, right: 0),
                      child: Icon(Icons.shopping_basket),
                    ),
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleTween.evaluate(animation),
                          child: child,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 0, right: 0),
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.black, width: 1),
                          color: Colors.white.withOpacity(.7),
                        ),
                        child: Center(
                          child: Text("0"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {},
            ),

            SizedBox(width: 10),
          ],
          bottom: TabBar(
            indicatorPadding: EdgeInsets.only(right: 6, left: 6),
            labelPadding: EdgeInsets.only(right: 6, left: 6),
            tabs: <Widget>[
              Tab(
                child: Text("VISÃO GERAL"),
              ),
              Tab(
                child: Text("INFORMAÇÕES"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            ProdutoDetalhesView(produto),
            ProdutoDetalhesInfo(produto),
          ],
        ),
        bottomNavigationBar: buildBottomNavigationBar(context),
      ),
    );
  }

  buildBottomNavigationBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: RaisedButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0),
                side: BorderSide(color: Colors.transparent),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProdutoPage();
                    },
                  ),
                );
              },
              color: Colors.grey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.list),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text("VER MAIS"),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: RaisedButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0),
                side: BorderSide(color: Colors.transparent),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProdutoPage();
                    },
                  ),
                );
              },
              color: Colors.orange[900],
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.shopping_basket),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text("VER MAIS"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
