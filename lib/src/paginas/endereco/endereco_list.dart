import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/endereco_controller.dart';
import 'package:nosso/src/core/model/endereco.dart';
import 'package:nosso/src/paginas/endereco/endereco_create_page.dart';
import 'package:nosso/src/util/load/circular_progresso.dart';

class EnderecoList extends StatefulWidget {
  @override
  _EnderecoListState createState() => _EnderecoListState();
}

class _EnderecoListState extends State<EnderecoList>
    with AutomaticKeepAliveClientMixin<EnderecoList> {
  EnderecoController enderecoController = GetIt.I.get<EnderecoController>();

  @override
  void initState() {
    enderecoController.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return enderecoController.getAll();
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
          List<Endereco> enderecos = enderecoController.enderecos;
          if (enderecoController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (enderecos == null) {
            return CircularProgressor();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(enderecos),
          );
        },
      ),
    );
  }

  ListView builderList(List<Endereco> enderecos) {
    double containerWidth = 160;
    double containerHeight = 30;

    return ListView.builder(
      itemCount: enderecos.length,
      itemBuilder: (context, index) {
        Endereco c = enderecos[index];

        return GestureDetector(
          child: Card(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      ConstantApi.urlNormal,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  Container(
                    width: containerWidth,
                    //color: Colors.grey[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: containerHeight,
                          width: containerWidth,
                          //color: Colors.grey[300],
                          child: Text("${c.logradouro}, ${c.numero}"),
                        ),
                        SizedBox(height: 2),
                        Container(
                          height: containerHeight,
                          width: containerWidth,
                          //color: Colors.grey[300],
                          child: Text(c.bairro),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 50,
                    child: buildPopupMenuButton(context, c),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {},
        );
      },
    );
  }

  PopupMenuButton<String> buildPopupMenuButton(
      BuildContext context, Endereco c) {
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
                return EnderecoCreatePage(
                  endereco: c,
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
