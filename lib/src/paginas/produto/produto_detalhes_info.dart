import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosso/src/core/model/produto.dart';

class ProdutoDetalhesInfo extends StatefulWidget {
  Produto p;

  ProdutoDetalhesInfo(this.p);

  @override
  _ProdutoDetalhesInfoState createState() => _ProdutoDetalhesInfoState();
}

class _ProdutoDetalhesInfoState extends State<ProdutoDetalhesInfo> {

  Produto p;

  @override
  Widget build(BuildContext context) {
    p = widget.p;

    return buildContainer(p);
  }

  Container buildContainer(Produto p) {
    return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          color: Colors.grey[200],
          width: double.infinity,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "${p.nome}",
              ),
              Text(
                "Código ${p.id}",
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(15),
          color: Colors.transparent,
          width: double.infinity,
          child: Text(
            "${p.descricao}",
          ),
        ),
        Container(
          padding: EdgeInsets.all(15),
          color: Colors.transparent,
          width: double.infinity,
          child: Text(
            "${p.loja.nome}",
          ),
        ),
        SizedBox(height: 10),
      ],
    ),
  );
  }
}
