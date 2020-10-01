
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosso/src/home/home.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: Stack(
        children: <Widget>[
          builderBodyBack(),
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
            Colors.grey[100],
            Colors.grey[100],
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
          color: Colors.orange,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                child: Icon(
                  Icons.account_circle,
                  size: 30,
                  color: Colors.black,
                ),
                maxRadius: 20,
                backgroundColor: Colors.yellow[700],
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 56,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Bem-vindo ao u-nosso",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ListTile(
          selected: true,
          leading: Icon(
            Icons.home,
          ),
          title: Text(
            "Home",
          ),
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
          selected: true,
          leading: Icon(
            Icons.search,
          ),
          title: Text(
            "Buscar",
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {},
        ),
        ListTile(
          selected: true,
          leading: Icon(
            Icons.account_circle,
          ),
          title: Text(
            "Minha Conta",
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {},
        ),
        ListTile(
          selected: true,
          leading: Icon(
            Icons.shopping_basket,
          ),
          title: Text(
            "Meus pedidos",
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {},
        ),
        ListTile(
          selected: true,
          leading: Icon(
            Icons.shop_two,
          ),
          title: Text(
            "Ofertas",
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {},
        ),
        ListTile(
          selected: true,
          leading: Icon(
            Icons.list,
          ),
          title: Text(
            "Categorias",
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {},
        ),
        ListTile(
          selected: true,
          leading: Icon(
            Icons.apps,
          ),
          title: Text(
            "Apps",
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {},
        ),
        ListTile(
          selected: true,
          leading: Icon(
            Icons.settings,
          ),
          title: Text(
            "Configurações",
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {},
        ),
        ListTile(
          selected: true,
          leading: Icon(
            Icons.ios_share,
          ),
          title: Text(
            "Sobre",
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {},
        )
      ],
    );
  }
}
