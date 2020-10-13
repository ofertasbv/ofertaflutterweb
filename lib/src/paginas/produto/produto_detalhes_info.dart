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
              padding: EdgeInsets.all(0),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(0),
                      width: double.infinity,
                      child: ListTile(
                        title: Text("Produto: ${p.nome}"),
                        subtitle: Text("Descrição: ${p.descricao}"),
                        trailing: Text("R\$: ${p.estoque.valor}"),
                      ),
                    ),
                  ),

                  Card(
                    child: Container(
                      padding: EdgeInsets.all(0),
                      width: double.infinity,
                      child: ListTile(
                        title: Text("Loja: ${p.loja.nome}"),
                        subtitle: Text("Oferta: ${p.promocao.nome}"),
                        trailing: Text("Quant: ${p.estoque.quantidade}"),
                      ),
                    ),
                  ),

                  Card(
                    child: Container(
                      padding: EdgeInsets.all(0),
                      width: double.infinity,
                      child: ListTile(
                        title: Text("SubCategoria: ${p.subCategoria.nome}"),
                        subtitle: Text("Marca: ${p.marca.nome}"),
                        trailing: Text("Descont: ${p.desconto}"),
                      ),
                    ),
                  ),

                  Card(
                    child: Container(
                      padding: EdgeInsets.all(0),
                      width: double.infinity,
                      child: ListTile(
                        title: Text("Origem: ${p.origem}"),
                        subtitle: Text("Tamanho: ${p.tamanho}"),
                        trailing: Text("Media: ${p.medida}"),
                      ),
                    ),
                  ),

                  Card(
                    child: Container(
                      padding: EdgeInsets.all(0),
                      width: double.infinity,
                      child: ListTile(
                        title: Text("CodBar: ${p.codigoBarra}"),
                        subtitle: Text("SKU: ${p.sku}"),
                        trailing: Text("Cor: ${p.cor}"),
                      ),
                    ),
                  ),

                  Card(
                    child: Container(
                      padding: EdgeInsets.all(0),
                      width: double.infinity,
                      child: ListTile(
                        title: Text("Favorito: ${p.favorito}"),
                        subtitle: Text("Destaque: ${p.destaque}"),
                        trailing: Text("Novo: ${p.novo}"),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
