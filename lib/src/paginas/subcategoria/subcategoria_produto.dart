import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/subcategoria_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/core/model/subcategoria.dart';
import 'package:nosso/src/paginas/produto/produto_detalhes_tab.dart';
import 'package:nosso/src/paginas/produto/produto_search.dart';
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
  SubCategoriaController subCategoriaController =
      GetIt.I.get<SubCategoriaController>();
  ProdutoController produtoController = GetIt.I.get<ProdutoController>();

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
        title: Text("Departamento - produtos"),
        actions: <Widget>[
          SizedBox(width: 20),
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              size: 30,
            ),
            onPressed: () {
              showSearch(context: context, delegate: ProdutoSearchDelegate());
            },
          ),
          GestureDetector(
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 16, right: 16),
                  child: Icon(
                    Icons.shopping_basket,
                    color: text == "0" ? Colors.white : Colors.white,
                    size: 26,
                  ),
                ),
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleTween.evaluate(animation),
                      child: child,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 12, right: 10),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black, width: 1),
                      color: Colors.purple,
                    ),
                    child: Center(
                      child: Text("0"),
                    ),
                  ),
                )
              ],
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => PedidoPage(),
              //   ),
              // );
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
            Container(
              padding: EdgeInsets.all(5),
              height: 150,
//              color: Colors.blue,
              child: builderConteudoListSubCategoria(),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 10),
              height: 50,
              width: double.infinity,
//              color: Colors.grey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    subCategoria == null ? "sem busca" : (subCategoria.nome),
                  ),
                  Observer(
                    builder: (context) {
                      if (produtoController.error != null) {
                        return Text("Não foi possível carregar");
                      }

                      if (produtoController.produtos == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Chip(
                        label: Text(
                          (produtoController.produtos.length ?? 0).toString(),
                          style: TextStyle(color: Colors.deepOrangeAccent),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 400,
              color: Colors.transparent,
              child: builderConteudoListProduto(),
            )
          ],
        ),
      ),
    );
  }

  builderConteudoListSubCategoria() {
    return Container(
      padding: EdgeInsets.only(top: 0),
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

  ListView builderListSubCategoria(List<SubCategoria> categorias) {
    double containerWidth = 110;
    double containerHeight = 15;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        SubCategoria c = categorias[index];

        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: AnimatedContainer(
              width: 100,
              duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          ConstantApi.urlArquivoSubCategoria + c.foto,
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
                        //color: Colors.grey[200],
                        child: Text(
                          c.nome,
                        ),
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
                      color: Colors.grey[300],
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

    return ListView.builder(
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];

        return GestureDetector(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 7.5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          ConstantApi.urlArquivoProduto + p.foto,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: containerHeight,
                            width: containerWidth,
                            //color: Colors.grey[300],
                            child: Text(p.nome),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: containerHeight,
                            width: containerWidth,
                            //color: Colors.grey[300],
                            child: Text(
                              p.loja != null ? (p.loja.nome) : "sem loja",
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 30,
                            width: containerWidth * 0.75,
                            //color: Colors.grey[300],
                            child: Text(
                              "R\$ ${p.estoque.valor}",
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
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
