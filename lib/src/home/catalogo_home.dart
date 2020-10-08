import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosso/src/home/categoria_list_home.dart';
import 'package:nosso/src/home/produto_list_home.dart';
import 'package:nosso/src/home/promocao_list_home.dart';
import 'package:nosso/src/paginas/loja/loja_create_page.dart';
import 'package:nosso/src/paginas/loja/loja_location.dart';
import 'package:nosso/src/paginas/produto/produto_create_page.dart';

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
          padding: EdgeInsets.all(10),
          color: Colors.white,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.green[500],
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "locais",
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return LojaLocation();
                      },
                    ),
                  );
                },
              ),
              VerticalDivider(color: Colors.grey),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.shopping_basket,
                      color: Colors.red[500],
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "publicar",
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return ProdutoCreatePage();
                      },
                    ),
                  );
                },
              ),
              VerticalDivider(color: Colors.grey),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.edit,
                      color: Colors.purple[500],
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "cadastre-se",
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return LojaCreatePage();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 2),
        Card(
          color: Colors.grey[100],
          elevation: 0,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    " departamento",
                  ),
                  FlatButton(
                    child: Text(
                      "veja mais",
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 2),
              Container(
                padding: EdgeInsets.all(2),
                height: 130,
                child: CategoriaListHome(),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        SizedBox(height: 2),
        Card(
          color: Colors.grey[100],
          elevation: 0,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    " ofertas",
                  ),
                  FlatButton(
                    child: Text(
                      "veja mais",
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 2),
              Container(
                height: 220,
                child: PromocaoListHome(),
              ),
            ],
          ),
        ),
        SizedBox(height: 2),
        Card(
          color: Colors.grey[100],
          elevation: 0,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    " produtos em destaque",
                  ),
                  FlatButton(
                    child: Text(
                      "veja mais",
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 2),
              Container(
                height: 130,
                child: ProdutoListHome(),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
