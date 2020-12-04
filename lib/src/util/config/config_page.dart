import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosso/src/home/home.dart';
import 'package:nosso/src/paginas/arquivo/arquivo_page.dart';
import 'package:nosso/src/paginas/categoria/categoria_page.dart';
import 'package:nosso/src/paginas/cliente/cliente_page.dart';
import 'package:nosso/src/paginas/cor/cor_page.dart';
import 'package:nosso/src/paginas/endereco/endereco_page.dart';
import 'package:nosso/src/paginas/loja/loja_page.dart';
import 'package:nosso/src/paginas/marca/marca_page.dart';
import 'package:nosso/src/paginas/pedido/pedido_page.dart';
import 'package:nosso/src/paginas/pedidoitem/pedidoitem_page.dart';
import 'package:nosso/src/paginas/permissao/permissao_page.dart';
import 'package:nosso/src/paginas/produto/produto_tab.dart';
import 'package:nosso/src/paginas/promocao/promocao_page.dart';
import 'package:nosso/src/paginas/subcategoria/subcategoria_page.dart';
import 'package:nosso/src/paginas/tamanho/tamanho_page.dart';
import 'package:nosso/src/paginas/usuario/usuario_page.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        actions: <Widget>[
          IconButton(
            icon: new Icon(
              Icons.home,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          builderBodyBack(),
          buildGridView(context),
        ],
      ),
    );
  }

  builderBodyBack() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[200],
              Colors.grey[200],
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );

  GridView buildGridView(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.only(top: 2),
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      crossAxisCount: 3,

      //childAspectRatio: MediaQuery.of(context).size.aspectRatio * 1.9,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProdutoTab();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.shopping_basket_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Center(
                child: Text("Produto"),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return CategoriaPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.list_alt_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Categoria",
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SubcategoriaPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.list_alt_sharp,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "SubCategoria",
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PromocaoPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.add_alert_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Oferta",
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return LojaPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Loja",
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ClientePage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.people_alt_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text("Cliente"),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return UsuarioPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text("Usuário"),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PermissaoPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.account_tree_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text("Permissão"),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ArquivoPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.photo_album_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text("Arquivo"),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return MarcaPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text("Marca"),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PedidoItemPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.shopping_basket_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text("Items"),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EnderecoPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.location_on_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text("Endereço"),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return CorPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.color_lens_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text("Cor"),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return TamanhoPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.format_size_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text("Tamanho"),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PedidoPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.yellow[900],
                  radius: 30,
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 30,
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
              Text("Pedido"),
            ],
          ),
        ),
      ],
    );
  }
}
