
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosso/src/home/categoria_list_home.dart';
import 'package:nosso/src/home/produto_list_home.dart';
import 'package:nosso/src/home/promocao_list_home.dart';
import 'package:nosso/src/paginas/cliente/cliente_create_page.dart';
import 'package:nosso/src/paginas/loja/loja_location.dart';
import 'package:nosso/src/paginas/produto/produto_create_page.dart';
import 'package:nosso/src/paginas/produto/produto_page.dart';
import 'package:nosso/src/paginas/promocao/promocao_page.dart';

class CatalogoHome extends StatefulWidget {
  @override
  _CatalogoHomeState createState() => _CatalogoHomeState();
}

class _CatalogoHomeState extends State<CatalogoHome> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        Container(
            color: Colors.grey[100],
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            padding: EdgeInsets.all(2),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  flex: 4,
                  child: RaisedButton.icon(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(0),
                      side: BorderSide(color: Colors.transparent),
                    ),
                    icon: Icon(
                      Icons.location_on_outlined,
                      size: 20,
                    ),
                    label: Text("local"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return LojaLocation();
                          },
                        ),
                      );
                    },
                    color: Colors.grey[100],
                  ),
                ),
                VerticalDivider(color: Colors.grey[300]),
                Flexible(
                  flex: 4,
                  child: RaisedButton.icon(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(0),
                      side: BorderSide(color: Colors.transparent),
                    ),
                    icon: Icon(
                      Icons.shopping_basket,
                      size: 20,
                    ),
                    label: Text("publicar"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProdutoCreatePage();
                          },
                        ),
                      );
                    },
                    color: Colors.grey[100],
                  ),
                ),
                VerticalDivider(color: Colors.grey[300]),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 4,
                  child: RaisedButton.icon(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(0),
                      side: BorderSide(color: Colors.transparent),
                    ),
                    icon: Icon(
                      Icons.account_circle_outlined,
                      size: 20,
                    ),
                    label: Text("Conta"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ClienteCreatePage();
                          },
                        ),
                      );
                    },
                    color: Colors.grey[100],
                  ),
                ),
              ],
            ),
          ),

        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10),
              height: 160,
              child: CategoriaListHome(),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(" ofertas"),
                  GestureDetector(
                    child: Text("veja mais"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return PromocaoPage();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 2),
            Container(
              height: 300,
              child: PromocaoListHome(),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(" produtos em destaque"),
                  GestureDetector(
                    child: Text("veja mais"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProdutoPage();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 2),
            Container(
              height: 130,
              child: ProdutoListHome(),
            ),
          ],
        ),
      ],
    );
  }
}
