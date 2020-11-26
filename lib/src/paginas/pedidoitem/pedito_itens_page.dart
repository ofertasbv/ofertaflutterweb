import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import 'package:intl/intl.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/pedidoItem_controller.dart';
import 'package:nosso/src/core/model/pedidoitem.dart';
import 'package:nosso/src/paginas/produto/produto_tab.dart';
import 'package:nosso/src/util/load/circular_progresso.dart';

class PedidoItensList extends StatefulWidget {
  @override
  _PedidoItensListState createState() => _PedidoItensListState();
}

class _PedidoItensListState extends State<PedidoItensList> {
  final pedidoItemController = GetIt.I.get<PedidoItemController>();

  final formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

  @override
  void initState() {
    pedidoItemController.pedidosItens();
    pedidoItemController.calculateTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return builderConteudoList();
  }

  builderConteudoList() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<PedidoItem> itens = pedidoItemController.itens;
          if (pedidoItemController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (itens == null) {
            return CircularProgressor();
          }

          if (itens.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.shopping_basket,
                      color: Colors.purple[300],
                      size: 100,
                    ),
                  ),
                  Text("Sua cesta está vazia"),
                  SizedBox(height: 10),
                  Text("Continue sua busca por produto"),
                  SizedBox(height: 20),
                  RaisedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProdutoTab();
                          },
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.yellow[800]),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    icon: Icon(
                      Icons.home,
                      color: Colors.purple,
                    ),
                    color: Colors.yellow[800],
                    label: Text(
                      "escolher produto",
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    elevation: 0,
                  ),
                ],
              ),
            );
          }

          return builderList(itens);
        },
      ),
    );
  }

  ListView builderList(List<PedidoItem> itens) {
    double containerWidth = 200;
    double containerHeight = 20;

    return ListView.builder(
      itemCount: itens.length,
      itemBuilder: (context, index) {
        PedidoItem p = itens[index];
        p.valorUnitario = p.produto.estoque.valor;
        p.valorTotal = (p.quantidade * p.valorUnitario);

        return GestureDetector(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 7.5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          ConstantApi.urlArquivoProduto + p.produto.foto,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 110,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: containerHeight,
                            width: containerWidth,
                            child: Text(
                              p.produto.nome,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: containerHeight,
                            width: containerWidth,
                            //color: Colors.grey[300],
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("valor unitário. "),
                                Text(
                                  "R\$ ${formatMoeda.format(p.valorUnitario)}",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: containerHeight,
                            width: containerWidth,
                            //color: Colors.grey[300],
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Valor total. "),
                                Text(
                                  "R\$ ${formatMoeda.format(p.valorTotal)}",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: containerWidth,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  width: 110,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                      color: Colors.grey[200]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      SizedBox(
                                        child: CircleAvatar(
                                          child: IconButton(
                                            icon: Icon(Icons
                                                .indeterminate_check_box_outlined),
                                            splashColor: Colors.black,
                                            onPressed: () {
                                              setState(() {
                                                print("removendo - ");
                                                print("${p.quantidade}");
                                                pedidoItemController
                                                    .decremento(p);
                                                pedidoItemController
                                                    .calculateTotal();
                                              });
                                            },
                                          ),
                                        ),
                                        width: 38,
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Text("${p.quantidade}"),
                                        ),
                                      ),
                                      SizedBox(
                                        child: CircleAvatar(
                                          child: IconButton(
                                            icon: Icon(Icons.add),
                                            splashColor: Colors.black,
                                            onPressed: () {
                                              setState(() {
                                                print("adicionando + ");
                                                print("${p.quantidade}");
                                                pedidoItemController
                                                    .incremento(p);
                                                pedidoItemController
                                                    .calculateTotal();
                                              });
                                            },
                                          ),
                                        ),
                                        width: 38,
                                      ),
                                    ],
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  foregroundColor: Colors.redAccent,
                                  radius: 20,
                                  child: IconButton(
                                    icon: Icon(Icons.delete_forever),
                                    splashColor: Colors.black,
                                    onPressed: () {
                                      showDialogAlert(context, p);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  showDialogAlert(BuildContext context, PedidoItem p) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Deseja remover este item?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${p.produto.nome}"),
                Text("Cod: ${p.produto.id}"),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      ConstantApi.urlArquivoProduto + p.produto.foto,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ],
            ),
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
                Icons.restore_from_trash,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.yellow[800]),
                borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
              label: Text('EXCLUIR'),
              color: Colors.yellow[800],
              elevation: 0,
              onPressed: () {
                setState(() {
                  pedidoItemController.remove(p);
                  pedidoItemController.itens;
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
