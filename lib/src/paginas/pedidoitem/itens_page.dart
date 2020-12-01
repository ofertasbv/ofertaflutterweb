import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/core/controller/pedidoItem_controller.dart';
import 'package:nosso/src/home/home.dart';
import 'package:nosso/src/paginas/pedido/pedido_create_page.dart';
import 'package:nosso/src/paginas/pedido/pedido_page.dart';
import 'package:nosso/src/paginas/pedidoitem/pedito_itens_page.dart';
import 'package:nosso/src/paginas/produto/produto_tab.dart';
import 'package:nosso/src/util/snackbar/snackbar_global.dart';

class ItemPage extends StatelessWidget {
  var pedidoItemController = GetIt.I.get<PedidoItemController>();
  var formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

  showToast(String cardTitle) {
    Fluttertoast.showToast(
      msg: "$cardTitle",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 20,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Itens pedido"),
        actions: <Widget>[
          Observer(
            builder: (context) {
              if (pedidoItemController.error != null) {
                return Text("Não foi possível carregar");
              }

              if (pedidoItemController.itens == null) {
                return Center(
                  child: Icon(Icons.warning_amber_outlined),
                );
              }

              return Chip(
                label: Text(
                  (pedidoItemController.itens.length ?? 0).toString(),
                ),
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: PedidoItensList(),
      bottomNavigationBar: buildBottomNavigationBar(context),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProdutoTab(),
            ),
          );
        },
      ),
    );
  }

  buildBottomNavigationBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0),
                side: BorderSide(color: Colors.transparent),
              ),
              elevation: 0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              color: Colors.purple[800],
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.home),
                    SizedBox(
                      width: 4.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0),
                side: BorderSide(color: Colors.transparent),
              ),
              elevation: 0,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PedidoPage();
                    },
                  ),
                );
              },
              color: Colors.purple[800],
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 4.0,
                    ),
                    Observer(
                      builder: (context) {
                        return Row(
                          children: <Widget>[
                            Text(
                              "TOTAL ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "R\$ ${formatMoeda.format(pedidoItemController.total)}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0),
                side: BorderSide(color: Colors.transparent),
              ),
              elevation: 0,
              onPressed: () {
                if (pedidoItemController.itens.isEmpty) {
                  showToast("seu carrinho está vazio!");
                  print("seu carrinho está vazio!");
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return PedidoCreatePage();
                      },
                    ),
                  );
                }
              },
              color: Colors.yellow[800],
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
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
