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
  SubCategoriaController subCategoriaController = GetIt.I.get<SubCategoriaController>();

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
            icon: Icon(
              CupertinoIcons.refresh,
            ),
            onPressed: () {
              subCategoriaController.getAll();
            },
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
            ),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Container(
        //color: Colors.grey,
        child: Row(
          children: <Widget>[
            Card(
              elevation: 0,
              color: Colors.grey[100],
              child: Container(
                padding: EdgeInsets.all(2),
                width: 110,
                child: builderConteudoListCategoria(),
              ),
            ),
            Card(
              elevation: 0,
              color: Colors.grey[100],
              child: Container(
                padding: EdgeInsets.all(2),
                width: 230,
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
                backgroundColor: Colors.purple,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow[800]),
              ),
            );
          }

          return builderListCategoria(categorias);
        },
      ),
    );
  }

  builderListCategoria(List<Categoria> categorias) {
    double containerWidth = 100;
    double containerHeight = 30;

    return GridView.builder(
      padding: EdgeInsets.only(top: 5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 0.9,
      ),
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        Categoria p = categorias[index];
        return GestureDetector(
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 2),
            curve: Curves.bounceIn,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 40,
                  minRadius: 40,
                  backgroundColor: Colors.white,
                  child: Image.network(
                    ConstantApi.urlArquivoCategoria + p.foto,
                  ),
                ),
                SizedBox(height: 0),
                Container(
                  padding: EdgeInsets.all(5),
                  height: 30,
                  width: containerWidth,
                  decoration: BoxDecoration(
                    color: p.nome == selectedCard
                        ? Colors.greenAccent
                        : Colors.white,
                  ),
                  child: Text(
                    p.nome,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            subCategoriaController.getAllByCategoriaById(p.id);
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
            return Center(child: CircularProgressIndicator(),);
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
    double containerWidth = double.infinity;
    double containerHeight = 30;

    return GridView.builder(
      padding: EdgeInsets.only(top: 5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 0.95,
      ),
      itemCount: subCategorias.length,
      itemBuilder: (context, index) {
        SubCategoria p = subCategorias[index];
        return GestureDetector(
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 2),
            curve: Curves.bounceIn,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 40,
                  minRadius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    ConstantApi.urlArquivoSubCategoria + p.foto,
                  ),
                ),
                SizedBox(height: 0),
                Container(
                  padding: EdgeInsets.all(5),
                  height: 30,
                  width: containerWidth,
                  color: Colors.transparent,
                  child: Text(
                    p.nome,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SubCategoriaProduto(
                    s: p,
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
