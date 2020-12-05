import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/categoria_controller.dart';
import 'package:nosso/src/core/controller/subcategoria_controller.dart';
import 'package:nosso/src/core/model/categoria.dart';
import 'package:nosso/src/core/model/subcategoria.dart';
import 'package:nosso/src/paginas/subcategoria/subcategoria_produto.dart';
import 'package:nosso/src/util/load/circular_progresso_mini.dart';

class CategoriaSubCategoria extends StatefulWidget {
  CategoriaSubCategoria();

  @override
  _CategoriaSubCategoriaState createState() => _CategoriaSubCategoriaState();
}

class _CategoriaSubCategoriaState extends State<CategoriaSubCategoria> {
  var categoriaController = GetIt.I.get<CategoriaController>();
  var subCategoriaController = GetIt.I.get<SubCategoriaController>();

  Categoria categoria;

  String selectedCard = 'WEIGHT';

  @override
  void initState() {
    if (categoria == null) {
      categoria = Categoria();
      subCategoriaController.getAll();
    } else {
      subCategoriaController.getAllByCategoriaById(categoria.id);
    }
    categoriaController.getAll();

    super.initState();
  }

  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    var text = "";
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Container(
            width: 80,
            color: Colors.grey[200],
            padding: EdgeInsets.all(0),
            child: builderConteudoListCategoria(),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 1),
              child: Column(
                children: [
                  Card(
                    elevation: 1,
                    child: Container(
                        padding: EdgeInsets.all(6),
                        color: Colors.transparent,
                        height: 110,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Departamentos"),
                                IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () {
                                    subCategoriaController.getAll();
                                    setState(() {
                                      categoria = categoria;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                categoria.nome == null
                                    ? Text(
                                        "todos os departamentos",
                                        style: TextStyle(
                                          color: Colors.yellow[900],
                                        ),
                                      )
                                    : Text(
                                        categoria.nome,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.yellow[900],
                                        ),
                                      ),
                                Observer(
                                  builder: (context) {
                                    if (subCategoriaController.error != null) {
                                      return Text("Não foi possível carregar");
                                    }

                                    if (subCategoriaController.subCategorias ==
                                        null) {
                                      return Center(
                                        child:
                                            Icon(Icons.warning_amber_outlined),
                                      );
                                    }

                                    return Chip(
                                      label: Text(
                                        (subCategoriaController
                                                    .subCategorias.length ??
                                                0)
                                            .toString(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: 0),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: builderConteutoListSubCategoria(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  builderConteudoListCategoria() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Categoria> categorias = categoriaController.categorias;
          if (categoriaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (categorias == null) {
            return CircularProgressorMini();
          }

          return builderListCategoria(categorias);
        },
      ),
    );
  }

  builderListCategoria(List<Categoria> categorias) {
    double containerWidth = 110;
    double containerHeight = 15;

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        Categoria c = categorias[index];

        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: Card(
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(2),
                side: BorderSide(color: Colors.grey[200], width: 1),
              ),
              child: AnimatedContainer(
                width: 80,
                height: 110,
                duration: Duration(seconds: 1),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      c.nome == selectedCard
                          ? Theme.of(context).accentColor.withOpacity(0.1)
                          : Colors.white,
                      c.nome == selectedCard
                          ? Theme.of(context).accentColor.withOpacity(0.1)
                          : Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple, Colors.grey[900]],
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        radius: 20,
                        backgroundImage: NetworkImage(
                          "${categoriaController.arquivo + c.foto}",
                        ),
                      ),
                    ),
                    SizedBox(height: 0),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      height: 40,
                      width: containerWidth,
                      child: Text(
                        c.nome.toLowerCase(),
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            selectCard(c.nome);
            print("id catgeoria ${c.id}");
            subCategoriaController.getAllByCategoriaById(c.id);
            setState(() {
              categoria = c;
            });
          },
        );
      },
    );
  }

  builderConteutoListSubCategoria() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<SubCategoria> subCategorias =
              subCategoriaController.subCategorias;
          if (subCategoriaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (subCategorias == null) {
            return Center(
              child: CircularProgressorMini(),
            );
          }

          if (subCategorias.length == 0) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.mood_outlined,
                      size: 100,
                    ),
                  ),
                  Text(
                    "Ops! sem departamento",
                  ),
                ],
              ),
            );
          }

          return builderListSubCategoria(subCategorias);
        },
      ),
    );
  }

  builderListSubCategoria(List<SubCategoria> subCategorias) {
    double containerWidth = 160;
    double containerHeight = 30;
    var orientation = MediaQuery.of(context).orientation;

    return GridView.builder(
      padding: EdgeInsets.only(top: 2),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4),
      scrollDirection: Axis.vertical,
      itemCount: subCategorias.length,
      itemBuilder: (context, index) {
        SubCategoria c = subCategorias[index];

        return GestureDetector(
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(2),
              side: BorderSide(color: Colors.grey[100], width: 1),
            ),
            child: Container(
              height: 80,
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    c.nome,
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    c.categoria.nome,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.yellow[900],
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SubCategoriaProduto(
                    c: c.categoria,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
