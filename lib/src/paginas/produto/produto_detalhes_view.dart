import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/pedidoItem_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
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

  AnimationController animationController;
  Animation<double> animation;
  static final _scaleTween = Tween<double>(begin: 1.0, end: 1.5);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFavorito = false;

  Produto produto;

  @override
  void initState() {
    if (produto == null) {
      produto = Produto();
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

  void showDefaultSnackbar(BuildContext context, String content) {
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

  favoritar() {
    this.isFavorito = !this.isFavorito;
    print("${this.isFavorito}");
  }

  buildContainer(Produto p) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.2,
          child: p.arquivos.isNotEmpty
              ? Carousel(
                  autoplay: false,
                  dotBgColor: Colors.transparent,
                  images: p.arquivos.map((a) {
                    return NetworkImage(ConstantApi.urlArquivoProduto + a.foto);
                  }).toList())
              : Image.network(
                  ConstantApi.urlArquivoProduto + p.foto,
                  fit: BoxFit.cover,
                ),
        ),
        Card(
          elevation: 0.2,
          child: ListTile(
            isThreeLine: true,
            leading: CircleAvatar(child: Icon(Icons.shopping_basket_outlined)),
            title: Text(
              p.nome,
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              "R\$ ${p.estoque.valor}",
              style: TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
            ),
            trailing: CircleAvatar(
              foregroundColor: Colors.redAccent,
              child: IconButton(
                splashColor: Colors.black,
                icon: (this.isFavorito == false
                    ? Icon(
                        Icons.favorite_border,
                        color: Colors.redAccent,
                      )
                    : Icon(
                        Icons.favorite_outlined,
                        color: Colors.redAccent,
                      )),
                onPressed: () {
                  setState(() {
                    favoritar();
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
