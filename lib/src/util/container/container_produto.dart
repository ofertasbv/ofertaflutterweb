import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/produto.dart';

class ContainerProduto extends StatelessWidget {
  ProdutoController produtoController;
  Produto p;

  ContainerProduto(this.produtoController, this.p);

  @override
  Widget build(BuildContext context) {
    var formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

    return Card(
      child: AnimatedContainer(
        width: 350,
        height: 160,
        duration: Duration(seconds: 1),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          children: [
            Container(
              height: 150,
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            produtoController.arquivo + p.foto,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 150,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: p.novo == true
                                ? Chip(
                                    label: Text(
                                      "novo",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : Chip(
                                    label: Text(
                                      "atual",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 230,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: ListTile(
                            title: Text("${p.nome}"),
                            subtitle: Text("Código. ${p.id}"),
                            trailing: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.redAccent,
                              child: IconButton(
                                splashColor: Colors.black,
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Colors.redAccent,
                                  size: 15,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: ListTile(
                            title: Text(
                              "R\$ ${formatMoeda.format(p.estoque.valor)}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.lineThrough,
                                decorationStyle: TextDecorationStyle.dashed,
                              ),
                            ),
                            subtitle: Text(
                              "R\$ ${formatMoeda.format(p.estoque.valor - ((p.estoque.valor * p.promocao.desconto) / 100))} a vista",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
