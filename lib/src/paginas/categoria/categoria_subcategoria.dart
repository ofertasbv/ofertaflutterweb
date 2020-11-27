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
  Categoria categoria;

  CategoriaSubCategoria({Key key, this.categoria}) : super(key: key);

  @override
  _CategoriaSubCategoriaState createState() =>
      _CategoriaSubCategoriaState(categoria: this.categoria);
}

class _CategoriaSubCategoriaState extends State<CategoriaSubCategoria> {
  var categoriaController = GetIt.I.get<CategoriaController>();
  var subCategoriaController = GetIt.I.get<SubCategoriaController>();

  Categoria categoria;

  _CategoriaSubCategoriaState({this.categoria});

  String selectedCard = 'WEIGHT';

  @override
  void initState() {
    if (categoria.id != null) {
      subCategoriaController.getAllByCategoriaById(categoria.id);
    } else {
      subCategoriaController.getAll();
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Departamento"),
        actions: <Widget>[
          Observer(
            builder: (context) {
              if (subCategoriaController.error != null) {
                return Text("Não foi possível carregar");
              }

              if (subCategoriaController.subCategorias == null) {
                return Center(
                  child: Icon(Icons.warning_amber_outlined),
                );
              }

              return Chip(
                label: Text(
                  (subCategoriaController.subCategorias.length ?? 0).toString(),
                ),
              );
            },
          ),
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5),
            Container(
              height: 150,
              padding: EdgeInsets.all(2),
              child: builderConteudoListCategoria(),
            ),
            Expanded(
              child: Card(
                child: Container(
                  child: builderConteutoListSubCategoria(),
                ),
              ),
            ),
          ],
        ),
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
      scrollDirection: Axis.horizontal,
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        Categoria c = categorias[index];

        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedContainer(
              width: 90,
              height: 150,
              duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    c.nome == selectedCard
                        ? Colors.purple[200]
                        : Colors.grey[200],
                    c.nome == selectedCard
                        ? Colors.purple[200]
                        : Colors.grey[200],
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10),
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
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      radius: 30,
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
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                  )
                ],
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
              child: CircularProgressIndicator(),
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

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: subCategorias.length,
      itemBuilder: (context, index) {
        SubCategoria c = subCategorias[index];

        return GestureDetector(
          child: ListTile(
              isThreeLine: true,
              leading: Container(
                padding: EdgeInsets.all(1),
                decoration: new BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.grey[900]],
                  ),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  radius: 25,
                  child: Text(
                    c.nome.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Text(c.nome),
              subtitle: Text("Cód: ${c.id}"),
              trailing: Icon(Icons.arrow_right)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SubCategoriaProduto(
                    s: c, c: c.categoria,
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
