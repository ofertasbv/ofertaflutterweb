import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/subcategoria_controller.dart';
import 'package:nosso/src/core/model/subcategoria.dart';
import 'package:nosso/src/util/load/circular_progresso.dart';

class SubCategoriaList extends StatefulWidget {
  @override
  _SubCategoriaListState createState() => _SubCategoriaListState();
}

class _SubCategoriaListState extends State<SubCategoriaList>
    with AutomaticKeepAliveClientMixin<SubCategoriaList> {
  final subCategoriaController = GetIt.I.get<SubCategoriaController>();

  @override
  void initState() {
    subCategoriaController.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return subCategoriaController.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return builderConteudoList();
  }

  builderConteudoList() {
    return Observer(
      builder: (context) {
        List<SubCategoria> categorias = subCategoriaController.subCategorias;
        if (subCategoriaController.error != null) {
          return Text("Não foi possível carregados dados");
        }

        if (categorias == null) {
          return CircularProgressor();
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: builderList(categorias),
        );
      },
    );
  }

  ListView builderList(List<SubCategoria> categorias) {
    double containerWidth = 100;
    double containerHeight = 40;

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        SubCategoria c = categorias[index];

        return GestureDetector(
          child: Column(
            children: <Widget>[
              Padding(
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
                          ConstantApi.urlArquivoSubCategoria + c.foto,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
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
                              child: Text(
                                c.nome,
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: containerHeight,
                              width: containerWidth,
                              //color: Colors.grey[300],
                              child: Text(
                                c.categoria.nome,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 50,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          ),
          onTap: () {},
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
