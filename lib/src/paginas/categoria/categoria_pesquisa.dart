import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/categoria_controller.dart';
import 'package:nosso/src/core/model/categoria.dart';
import 'package:nosso/src/paginas/categoria/categoria_subcategoria.dart';

class CategoriaPesquisa extends StatefulWidget {
  @override
  _CategoriaPesquisaState createState() => _CategoriaPesquisaState();
}

class _CategoriaPesquisaState extends State<CategoriaPesquisa> {
  var categoriaController = GetIt.I.get<CategoriaController>();

  @override
  void initState() {
    categoriaController.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: builderConteudoList(),
    );
  }

  builderConteudoList() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      color: Colors.white,
      child: Observer(
        builder: (context) {
          List<Categoria> categorias = categoriaController.categorias;
          if (categoriaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (categorias == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return builderList(categorias);
        },
      ),
    );
  }

  ListView builderList(List<Categoria> categorias) {
    double containerWidth = 160;
    double containerHeight = 30;

    return ListView.separated(
      itemCount: categorias.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        Categoria c = categorias[index];

        return GestureDetector(
          child: ListTile(
              isThreeLine: true,
              leading: Container(
                padding: EdgeInsets.all(1),
                decoration: new BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.orange[900]],
                  ),
                  border: Border.all(
                    color: Colors.deepOrangeAccent,
                    width: 2,
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
              title: Text(c.nome),
              subtitle: Text("cod: ${c.id}"),
              trailing: Icon(Icons.arrow_forward_outlined)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return CategoriaSubCategoria(
                    categoria: c,
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
