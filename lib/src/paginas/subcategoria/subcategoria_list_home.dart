import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/subcategoria_controller.dart';
import 'package:nosso/src/core/model/subcategoria.dart';

class SubCategoriaListHome extends StatefulWidget {
  @override
  _SubCategoriaListHomeState createState() => _SubCategoriaListHomeState();
}

class _SubCategoriaListHomeState extends State<SubCategoriaListHome>
    with AutomaticKeepAliveClientMixin<SubCategoriaListHome> {
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
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.purple,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow[800]),
            ),
          );
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
    double containerHeight = 15;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        SubCategoria c = categorias[index];

        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              height: 200,
              width: 200,
              //margin: EdgeInsets.symmetric(vertical: 7.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.black12,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 40,
                    minRadius: 40,
                    backgroundColor: Colors.white,
                    child: Image.network(
                      ConstantApi.urlArquivoSubCategoria + c.foto,
                      fit: BoxFit.fill,
                      width: 90,
                      height: 90,
                    ),
                  ),
                  SizedBox(height: 0),
                  Container(
                    padding: EdgeInsets.all(5),
                    height: 30,
                    width: containerWidth,
                    color: Colors.transparent,
                    child: Center(
                      child: Text(
                        c.nome,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            print("categoria: ${c.nome}");
          },
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
