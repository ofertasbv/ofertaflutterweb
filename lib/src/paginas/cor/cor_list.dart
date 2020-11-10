import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/cor_controller.dart';
import 'package:nosso/src/core/model/cor.dart';
import 'package:nosso/src/paginas/cor/cor_create_page.dart';
import 'package:nosso/src/util/load/circular_progresso.dart';

class CorList extends StatefulWidget {
  @override
  _CorListState createState() => _CorListState();
}

class _CorListState extends State<CorList>
    with AutomaticKeepAliveClientMixin<CorList> {
  CorController corController = GetIt.I.get<CorController>();

  @override
  void initState() {
    corController.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return corController.getAll();
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
          List<Cor> cores = corController.cores;
          if (corController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (cores == null) {
            return CircularProgressor();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(cores),
          );
        },
      ),
    );
  }

  builderList(List<Cor> cores) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.separated(
      itemCount: cores.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        Cor c = cores[index];

        return GestureDetector(
          child: ListTile(
            isThreeLine: true,
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              maxRadius: 35,
              minRadius: 35,
              child: Icon(Icons.shopping_bag),
            ),
            title: Text(c.descricao),
            subtitle: Text("cod: ${c.id}"),
            trailing: Container(
              height: 80,
              width: 50,
              child: buildPopupMenuButton(context, c),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return CorCreatePage(
                    cor: c,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  PopupMenuButton<String> buildPopupMenuButton(BuildContext context, Cor c) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert),
      onSelected: (valor) {
        if (valor == "novo") {
          print("novo");
        }
        if (valor == "editar") {
          print("editar");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return CorCreatePage(
                  cor: c,
                );
              },
            ),
          );
        }
        if (valor == "delete") {
          print("delete");
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
            title: Text('Delete'),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
