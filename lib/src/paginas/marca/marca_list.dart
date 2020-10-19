import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/marca_controller.dart';
import 'package:nosso/src/core/model/marca.dart';
import 'package:nosso/src/paginas/marca/marca_create_page.dart';
import 'package:nosso/src/util/load/circular_progresso.dart';

class MarcaList extends StatefulWidget {
  @override
  _MarcaListState createState() => _MarcaListState();
}

class _MarcaListState extends State<MarcaList>
    with AutomaticKeepAliveClientMixin<MarcaList> {
  MarcaController marcaController = GetIt.I.get<MarcaController>();

  @override
  void initState() {
    marcaController.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return marcaController.getAll();
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
          List<Marca> marcas = marcaController.marcas;
          if (marcaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (marcas == null) {
            return CircularProgressor();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(marcas),
          );
        },
      ),
    );
  }

  ListView builderList(List<Marca> marcas) {
    double containerWidth = 160;
    double containerHeight = 30;

    return ListView.builder(
      itemCount: marcas.length,
      itemBuilder: (context, index) {
        Marca c = marcas[index];

        return Column(
          children: [
            GestureDetector(
              child: ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  maxRadius: 35,
                  minRadius: 35,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(100.0),
                    child: Image.asset(ConstantApi.urlLogo),
                  ),
                ),
                title: Text(c.nome),
                subtitle: Text("${c.id}"),
                trailing: Container(
                  height: 80,
                  width: 50,
                  child: buildPopupMenuButton(context, c),
                ),
              ),
              onTap: () {},
            ),
            Divider()
          ],
        );
      },
    );
  }

  PopupMenuButton<String> buildPopupMenuButton(BuildContext context, Marca c) {
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
                return MarcaCreatePage(
                  marca: c,
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
