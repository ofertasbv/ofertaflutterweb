import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosso/src/home/catalogo_menu.dart';
import 'package:nosso/src/home/home.dart';
import 'package:nosso/src/paginas/categoria/categoria_page.dart';
import 'package:nosso/src/paginas/loja/loja_page.dart';
import 'package:nosso/src/paginas/produto/produto_search.dart';
import 'package:nosso/src/paginas/promocao/promocao_page.dart';
import 'package:nosso/src/util/config/config_page.dart';
import 'package:nosso/src/util/sobre/sobre_page.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: Stack(
        children: <Widget>[
          menuLateral(context),
        ],
      ),
    );
  }

  builderBodyBack() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  ListView menuLateral(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10),
          color: Colors.grey[100],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                child: Icon(
                  Icons.account_circle,
                  size: 25,
                  color: Colors.black,
                ),
                maxRadius: 15,
                backgroundColor: Colors.orangeAccent,
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 56,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Bem-vindo ao u-nosso"),
                  ],
                ),
              ),
            ],
          ),
        ),
        ListTile(
          selected: false,
          leading: Icon(Icons.home),
          title: Text("Home"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return HomePage();
                },
              ),
            );
          },
        ),
        ListTile(
          selected: false,
          leading: Icon(Icons.search),
          title: Text("Buscar"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            showSearch(
              context: context,
              delegate: ProdutoSearchDelegate(),
            );
          },
        ),
        ListTile(
          selected: false,
          leading: Icon(Icons.account_circle),
          title: Text("Minha Conta"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return LojaPage();
                },
              ),
            );
          },
        ),
        ListTile(
          selected: false,
          leading: Icon(Icons.shopping_basket),
          title: Text("Meus pedidos"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {},
        ),
        ListTile(
          selected: false,
          leading: Icon(Icons.shop_two),
          title: Text("Ofertas"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PromocaoPage();
                },
              ),
            );
          },
        ),
        ListTile(
          selected: false,
          leading: Icon(Icons.list),
          title: Text("Categorias"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return CategoriaPage();
                },
              ),
            );
          },
        ),
        ListTile(
          selected: false,
          leading: Icon(Icons.apps),
          title: Text("Apps"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CatalogoMenu(),
              ),
            );
          },
        ),
        ListTile(
          selected: false,
          leading: Icon(Icons.settings),
          title: Text("Configurações"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ConfigPage();
                },
              ),
            );
          },
        ),
        ListTile(
          selected: false,
          leading: Icon(Icons.ios_share),
          title: Text("Sobre"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SobrePage();
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
