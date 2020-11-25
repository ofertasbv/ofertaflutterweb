import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/favorito_controller.dart';
import 'package:nosso/src/core/controller/pedidoItem_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/favorito.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ProdutoDetalhesView extends StatefulWidget {
  Produto p;

  ProdutoDetalhesView(this.p);

  @override
  _ProdutoDetalhesViewState createState() => _ProdutoDetalhesViewState();
}

class _ProdutoDetalhesViewState extends State<ProdutoDetalhesView>
    with SingleTickerProviderStateMixin {
  var pedidoItemController = GetIt.I.get<PedidoItemController>();
  var produtoController = GetIt.I.get<ProdutoController>();
  var favoritoController = GetIt.I.get<FavoritoController>();

  AnimationController animationController;
  Animation<double> animation;
  static final _scaleTween = Tween<double>(begin: 1.0, end: 1.5);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFavorito = false;

  Produto produto;
  Favorito favorito;

  @override
  void initState() {
    if (produto == null) {
      produto = Produto();
      favorito = Favorito();
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

  showSnackbar(BuildContext context, String content) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    produto = widget.p;
    return buildContainer(produto);
  }

  favoritar(Produto p) {
    this.isFavorito = !this.isFavorito;
    print("${isFavorito}");
  }

  buildContainer(Produto p) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: p.arquivos.isNotEmpty
              ? Carousel(
                  autoplay: false,
                  dotBgColor: Colors.transparent,
                  images: p.arquivos.map((a) {
                    return NetworkImage(produtoController.arquivo + a.foto);
                  }).toList())
              : Image.network(
                  produtoController.arquivo + p.foto,
                  fit: BoxFit.cover,
                ),
        ),
        Card(
          child: Container(
            child: ListTile(
              title: Text(
                p.nome,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                "Cód. ${p.id}",
                style: TextStyle(fontSize: 20),
              ),
              trailing: CircleAvatar(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.redAccent,
                radius: 15,
                child: IconButton(
                  splashColor: Colors.black,
                  icon: (this.favorito == false
                      ? Icon(
                          Icons.favorite_border,
                          color: Colors.redAccent,
                          size: 15,
                        )
                      : Icon(
                          Icons.favorite_outlined,
                          color: Colors.redAccent,
                          size: 15,
                        )),
                  onPressed: () {
                    setState(() {
                      print("Favoritar: ${p.nome}");
                      favoritar(p);
                    });

                    if (favorito.id == null) {
                      favorito.produto = p;
                      favorito.status = isFavorito;
                      favoritoController.create(favorito);
                      print("Adicionar: ${p.nome}");
                    } else {
                      favorito.produto = p;
                      favorito.status = isFavorito;
                      favoritoController.update(favorito.id, favorito);
                      print("Alterar: ${p.nome}");
                      showSnackbar(context, "favorito");
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        Card(
          elevation: 0.2,
          child: ListTile(
            isThreeLine: true,
            title: Text(
              "De ${p.estoque.valor}0",
              style: TextStyle(
                fontSize: 14,
                decoration: TextDecoration.lineThrough,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
            subtitle: Text(
              "R\$ ${p.estoque.valor - ((p.estoque.valor * p.promocao.desconto) / 100)}0",
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Chip(
              label: Text(
                "- ${p.promocao.desconto}%",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
