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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Container(
            height: 160,
            width: double.infinity,
            color: Colors.transparent,
            padding: EdgeInsets.all(0),
            child: builderConteudoListCategoria(),
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: builderConteutoListSubCategoria(),
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
      scrollDirection: Axis.horizontal,
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        Categoria c = categorias[index];

        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey[200], width: 1),
              ),
              child: AnimatedContainer(
                width: 90,
                height: 150,
                duration: Duration(seconds: 1),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      c.nome == selectedCard
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : Colors.grey[100].withOpacity(0.1),
                      c.nome == selectedCard
                          ? Theme.of(context).primaryColor.withOpacity(0.4)
                          : Colors.grey[400].withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
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
                          colors: [Colors.indigo, Colors.grey[900]],
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
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

  builderListSubCategoria(List<SubCategoria> categorias) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        SubCategoria c = categorias[index];

        return GestureDetector(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey[200], width: 1),
            ),
            child: Container(
              child: ListTile(
                isThreeLine: true,
                leading: Container(
                  padding: EdgeInsets.all(1),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[500].withOpacity(0.2),
                    foregroundColor: Colors.indigo[900],
                    radius: 20,
                    child: Text(
                      c.nome.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(c.nome),
                subtitle: Text("${c.categoria.nome}"),
                trailing: Container(
                  height: 80,
                  width: 50,
                  child: Icon(Icons.arrow_right),
                ),
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
