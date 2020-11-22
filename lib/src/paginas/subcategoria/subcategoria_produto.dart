import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/core/controller/subcategoria_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/core/model/subcategoria.dart';
import 'package:nosso/src/paginas/produto/produto_detalhes_tab.dart';
import 'package:nosso/src/util/load/circular_progresso.dart';

class SubCategoriaProduto extends StatefulWidget {
  SubCategoria s;

  SubCategoriaProduto({Key key, this.s}) : super(key: key);

  @override
  _SubCategoriaProdutoState createState() =>
      _SubCategoriaProdutoState(subCategoria: this.s);
}

class _SubCategoriaProdutoState extends State<SubCategoriaProduto>
    with SingleTickerProviderStateMixin {
  var subCategoriaController = GetIt.I.get<SubCategoriaController>();
  var produtoController = GetIt.I.get<ProdutoController>();

  SubCategoria subCategoria;
  var selectedCard = 'WEIGHT';

  _SubCategoriaProdutoState({this.subCategoria});

  AnimationController animationController;
  Animation<double> animation;
  static final _scaleTween = Tween<double>(begin: 1.0, end: 1.5);

  @override
  void initState() {
    subCategoriaController.getAll();
    if (subCategoria.id == null) {
      produtoController.getAll();
    }
    if (subCategoria.id != null) {
      produtoController.getAllBySubCategoriaById(subCategoria.id);
    }

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceInOut,
    );

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var text = "";

    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos por departamento"),
        actions: <Widget>[
          Observer(
            builder: (context) {
              if (produtoController.error != null) {
                return Text("Não foi possível carregar");
              }

              if (produtoController.produtos == null) {
                return Center(
                  child: Icon(Icons.warning_amber_outlined),
                );
              }

              return Chip(
                label: Text(
                  (produtoController.produtos.length ?? 0).toString(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh_outlined),
            onPressed: () {
              produtoController.getAll();
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: Container(
                height: 60,
                padding: EdgeInsets.all(4),
                child: builderConteudoListSubCategoria(),
              ),
            ),
            Expanded(
              child: Card(
                child: Container(
                  child: builderConteudoListProduto(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  builderConteudoListSubCategoria() {
    return Container(
      child: Observer(
        builder: (context) {
          List<SubCategoria> categorias = subCategoriaController.subCategorias;
          if (subCategoriaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (categorias == null) {
            return CircularProgressor();
          }

          return builderListSubCategoria(categorias);
        },
      ),
    );
  }

  builderListSubCategoria(List<SubCategoria> categorias) {
    double containerWidth = 110;
    double containerHeight = 15;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        SubCategoria c = categorias[index];

        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Chip(
              label: Text(c.nome.toLowerCase()),
              backgroundColor: c.nome == selectedCard
                  ? Colors.orange[200]
                  : Colors.grey[200],
            ),
          ),
          onTap: () {
            selectCard(c.nome);
            print("id catgeoria ${c.id}");
            produtoController.getAllBySubCategoriaById(c.id);
            setState(() {
              subCategoria = c;
            });
          },
        );
      },
    );
  }

  builderConteudoListProduto() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Produto> produtos = produtoController.produtos;
          if (produtoController.error != null) {
            return Text("Não foi possível buscar produtos");
          }

          if (produtos == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (produtos.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.mood_bad,
                      size: 100,
                    ),
                  ),
                  Text("Ops! sem produtos pra esse departamento"),
                ],
              ),
            );
          }

          return builderListProduto(produtos);
        },
      ),
    );
  }

  ListView builderListProduto(List<Produto> produtos) {
    double containerWidth = 200;
    double containerHeight = 30;

    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return ListView.separated(
      itemCount: produtos.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        Produto p = produtos[index];

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
                radius: 25,
                backgroundImage: NetworkImage(
                  "${produtoController.arquivo + p.foto}",
                ),
              ),
            ),
            title: Text(p.nome),
            subtitle: Text("${dateFormat.format(p.dataRegistro)}"),
            trailing: Text(
              "R\$ ${p.estoque.valor}",
              style: TextStyle(color: Colors.green, fontSize: 18),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProdutoDetalhesTab(p);
                },
              ),
            );
          },
        );
      },
    );
  }

  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }
}
