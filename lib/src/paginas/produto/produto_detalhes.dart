import 'package:flutter/material.dart';

class ProdutoDetalhes extends StatefulWidget {
  @override
  _ProdutoDetalhesState createState() => _ProdutoDetalhesState();
}

class _ProdutoDetalhesState extends State<ProdutoDetalhes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teste"),
      ),
      body: Center(
        child: Text("Produtos detallhes"),
      ),
    );
  }
}
