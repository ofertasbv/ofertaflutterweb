import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/promocao_controller.dart';
import 'package:nosso/src/core/model/promocao.dart';
import 'package:nosso/src/paginas/produto/produto_search.dart';
import 'package:nosso/src/paginas/produto/produto_tab.dart';
import 'package:nosso/src/paginas/promocao/promocao_detalhes-view.dart';
import 'package:nosso/src/paginas/promocao/promocao_detalhes_info.dart';

class PromocaoDetalhesTab extends StatefulWidget {
  Promocao p;

  PromocaoDetalhesTab(this.p);

  @override
  _PromocaoDetalhesTabState createState() => _PromocaoDetalhesTabState();
}

class _PromocaoDetalhesTabState extends State<PromocaoDetalhesTab>
    with SingleTickerProviderStateMixin {
  var promocaoController = GetIt.I.get<PromoCaoController>();
  Promocao promocao;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    promocao = widget.p;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(promocao.nome),
          actions: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.purple[800],
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
            PromocaoDetalhesView(promocao),
            PromocaoDetalhesInfo(promocao)
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
                      return ProdutoTab();
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
                    Text("MAIS"),
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
                      return ProdutoTab();
                    },
                  ),
                );
              },
              color: Colors.yellow[800],
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.shopping_basket),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text("LISTA DE DESEJO"),
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
