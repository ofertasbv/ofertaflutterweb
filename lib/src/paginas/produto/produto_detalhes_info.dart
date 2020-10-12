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
          Card(
            child: Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("${p.nome}"),
                  Text("Código ${p.id}"),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: Text("${p.descricao}"),
            ),
          ),
          Card(
            child: Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: Text(
                "${p.loja.nome}",
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
