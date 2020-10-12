import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/categoria_controller.dart';
import 'package:nosso/src/core/controller/subcategoria_controller.dart';
import 'package:nosso/src/core/model/categoria.dart';
import 'package:nosso/src/core/model/subcategoria.dart';
import 'package:nosso/src/paginas/subcategoria/subcategoria_produto.dart';

class CategoriaSubCategoria extends StatefulWidget {
  Categoria categoria;

  CategoriaSubCategoria({Key key, this.categoria}) : super(key: key);

  @override
  _CategoriaSubCategoriaState createState() =>
      _CategoriaSubCategoriaState(categoria: this.categoria);
}

class _CategoriaSubCategoriaState extends State<CategoriaSubCategoria> {
  CategoriaController categoriaController = GetIt.I.get<CategoriaController>();
  SubCategoriaController subCategoriaController =
      GetIt.I.get<SubCategoriaController>();

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
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: Container(
                padding: EdgeInsets.all(2),
                height: 140,
                child: builderConteudoListCategoria(),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(2),
                height: 50,
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Chip(
                      backgroundColor: Colors.amber,
                      label: Text(
                        categoria == null ? "sem busca" : (categoria.nome),
                      ),
                    ),
                    Observer(
                      builder: (context) {
                        if (subCategoriaController.error != null) {
                          return Text("Não foi possível carregar");
                        }

                        if (subCategoriaController.subCategorias == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Chip(
                          backgroundColor: Colors.amber,
                          label: Text(
                            (subCategoriaController.subCategorias.length ?? 0)
                                .toString(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(2),
                height: 380,
                color: Colors.transparent,
                child: builderConteutoListSubCategoria(),
              ),
            )
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
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.indigo[900],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            );
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
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: AnimatedContainer(
              width: 100,
              duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color:
                    c.nome == selectedCard ? Colors.greenAccent : Colors.white,
              ),
              margin: EdgeInsets.symmetric(vertical: 7.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Image.network(
                          ConstantApi.urlArquivoCategoria + c.foto,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 80,
                        ),
                      ),
                      SizedBox(height: 0),
                      Container(
                        padding: EdgeInsets.all(5),
                        height: 40,
                        width: containerWidth,
                        color: Colors.grey[100],
                        child: Text(c.nome),
                      ),
                    ],
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
                      Icons.mood_bad,
                      color: Colors.grey[300],
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
          child: Card(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Image.network(
                      ConstantApi.urlArquivoSubCategoria + c.foto,
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
                          child: Text(c.nome),
                        ),
                        SizedBox(height: 2),
                        Container(
                          height: containerHeight,
                          width: containerWidth,
                          //color: Colors.grey[300],
                          child: Text(c.categoria.nome),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 50,
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
                    s: c,
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
