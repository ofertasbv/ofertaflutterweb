import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/categoria_controller.dart';
import 'package:nosso/src/core/controller/subcategoria_controller.dart';
import 'package:nosso/src/core/model/categoria.dart';
import 'package:nosso/src/core/model/subcategoria.dart';
import 'package:nosso/src/paginas/subcategoria/subcategoria_produto.dart';

class CategoriaSubCategoria extends StatefulWidget {
  Categoria c;

  CategoriaSubCategoria({Key key, this.c}) : super(key: key);

  @override
  _CategoriaSubCategoriaState createState() =>
      _CategoriaSubCategoriaState(c: this.c);
}

class _CategoriaSubCategoriaState extends State<CategoriaSubCategoria> {
  CategoriaController categoriaController = GetIt.I.get<CategoriaController>();
  SubCategoriaController subCategoriaController =
      GetIt.I.get<SubCategoriaController>();

  Categoria c;

  _CategoriaSubCategoriaState({this.c});

  var selectedCard = 'WEIGHT';

  @override
  void initState() {
    if (c.id != null) {
      subCategoriaController.getAllByCategoriaById(c.id);
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Departamento"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              subCategoriaController.getAll();
            },
          ),
        ],
      ),
      body: Container(
        //color: Colors.grey,
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(2),
              width: 80,
              child: builderConteudoListCategoria(),
            ),
            Container(
              padding: EdgeInsets.all(2),
              width: 262,
              child: builderConteutoListSubCategoria(),
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
    double containerWidth = 80;
    double containerHeight = 30;

    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        Categoria c = categorias[index];
        return Column(
          children: [
            GestureDetector(
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0),
                ),
                duration: Duration(seconds: 2),
                curve: Curves.bounceIn,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2)),
                        color: Colors.yellow,
                      ),
                      child: Image.network(
                        ConstantApi.urlArquivoCategoria + c.foto,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 51,
                      ),
                    ),
                    SizedBox(height: 0),
                    Container(
                      padding: EdgeInsets.all(5),
                      height: 30,
                      width: containerWidth,
                      color: Colors.white,
                      child: Center(
                        child: Text(c.nome),
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
              onTap: () {
                subCategoriaController.getAllByCategoriaById(c.id);
              },
            ),
            Divider()
          ],
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
    double containerWidth = 200;
    double containerHeight = 30;

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: subCategorias.length,
      itemBuilder: (context, index) {
        SubCategoria c = subCategorias[index];

        return Column(
          children: [
            GestureDetector(
              child: Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image.network(
                        ConstantApi.urlArquivoSubCategoria + c.foto,
                        fit: BoxFit.cover,
                        width: 80,
                        height: 85,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(c.nome),
                          Text(c.categoria.nome),
                        ],
                      ),
                    )
                  ],
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
            ),
            Divider()
          ],
        );
      },
    );
  }
}
