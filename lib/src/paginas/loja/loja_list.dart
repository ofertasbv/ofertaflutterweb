import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/loja_controller.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/paginas/loja/loja_detalhes.dart';
import 'package:nosso/src/util/load/circular_progresso.dart';

class LojaList extends StatefulWidget {
  @override
  _LojaListState createState() => _LojaListState();
}

class _LojaListState extends State<LojaList>
    with AutomaticKeepAliveClientMixin<LojaList> {
  LojaController lojaController = GetIt.I.get<LojaController>();

  @override
  void initState() {
    lojaController.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return lojaController.getAll();
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
          List<Loja> lojas = lojaController.lojas;
          if (lojaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (lojas == null) {
            return CircularProgressor();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(lojas),
          );
        },
      ),
    );
  }

  ListView builderList(List<Loja> lojas) {
    double containerWidth = 160;
    double containerHeight = 30;

    return ListView.builder(
      itemCount: lojas.length,
      itemBuilder: (context, index) {
        Loja p = lojas[index];

        return Column(
          children: <Widget>[
            GestureDetector(
              child: Padding(
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
                          ConstantApi.urlArquivoLoja + p.foto,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Container(
                        //color: Colors.grey[200],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 35,
                              width: containerWidth,
                              //color: Colors.grey[300],
                              child: Text(
                                p.razaoSocial,
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 40,
                              width: containerWidth,
                              color: Colors.grey[100],
                             child: Text(
                               "${p.enderecos[0].logradouro}, ${p.enderecos[0].numero} - ${p.enderecos[0].bairro}",
                             ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 50,
                        //color: Colors.grey[300],
                        child: buildPopupMenuButton(context, p),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return LojaDetalhes(
                        loja: p,
                      );
                    },
                  ),
                );
              },
            ),
            Divider(),
          ],
        );
      },
    );
  }

  PopupMenuButton<String> buildPopupMenuButton(BuildContext context, Loja p) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert),
      onSelected: (valor) {
        if (valor == "novo") {
          print("novo");
        }

        if (valor == "editar") {
          print("editar");
        }
        if (valor == "delete") {
          print("delete");
        }

        if (valor == "local") {
          print("local");
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'novo',
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('novo'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'editar',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('editar'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('delete'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'local',
          child: ListTile(
            leading: Icon(Icons.location_on),
            title: Text('local'),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
