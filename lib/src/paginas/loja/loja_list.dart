import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/core/controller/loja_controller.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/paginas/loja/loja_create_page.dart';
import 'package:nosso/src/paginas/loja/loja_detalhes.dart';
import 'package:nosso/src/util/load/circular_progresso.dart';

class LojaList extends StatefulWidget {
  @override
  _LojaListState createState() => _LojaListState();
}

class _LojaListState extends State<LojaList>
    with AutomaticKeepAliveClientMixin<LojaList> {
  var lojaController = GetIt.I.get<LojaController>();

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

    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    return ListView.builder(
      itemCount: lojas.length,
      itemBuilder: (context, index) {
        Loja p = lojas[index];
        print("${p.dataRegistro}");

        return GestureDetector(
          child: ListTile(
            isThreeLine: true,
            leading: Container(
              padding: EdgeInsets.all(1),
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.orange[900]],
                ),
                border: Border.all(
                  color: Colors.deepOrangeAccent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(35),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.grey[100],
                radius: 25,
                backgroundImage: NetworkImage(
                  "${lojaController.arquivo + p.foto}",
                ),
              ),
            ),
            title: Text(p.nome),
            subtitle: Text("${p.telefone}"),
            trailing: Container(
              height: 80,
              width: 50,
              child: buildPopupMenuButton(context, p),
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
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return LojaCreatePage(
                  loja: p,
                );
              },
            ),
          );
        }

        if (valor == "detalhes") {
          print("detalhes");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return LojaDetalhes(
                  loja: p,
                );
              },
            ),
          );
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
          value: 'detalhes',
          child: ListTile(
            leading: Icon(Icons.search),
            title: Text('detalhes'),
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
