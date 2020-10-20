import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosso/src/home/catalogo_home.dart';
import 'package:nosso/src/home/catalogo_menu.dart';
import 'package:nosso/src/home/drawer_list.dart';
import 'package:nosso/src/paginas/categoria/categoria_list.dart';
import 'package:nosso/src/paginas/loja/loja_list.dart';
import 'package:nosso/src/paginas/produto/produto_list.dart';
import 'package:nosso/src/paginas/produto/produto_search.dart';
import 'package:nosso/src/paginas/promocao/promocao_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  int elementIndex = 0;

  PageController pageController;

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottomOpacity: 0.0,
          title: Text(
            "U-NOSSO",
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search_outlined),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ProdutoSearchDelegate(),
                );
              },
            ),
            buildGestureDetector(context),
            IconButton(
              icon: Icon(Icons.apps),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CatalogoMenu(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Center(child: lista[elementIndex]),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                'home',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text(
                'departamento',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_convenience_store),
              title: Text(
                'loja',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_alert),
              title: Text(
                'oferta',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              title: Text(
                'pedido',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          currentIndex: elementIndex,
          onTap: changeIndex,
          elevation: 4,
        ),

/* ======================= Menu lateral ======================= */
        drawer: DrawerList(),
/* ======================= Botão Flutuante ======================= */
      ),
    );
  }

  buildGestureDetector(BuildContext context) {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 2, right: 2),
            child: Icon(Icons.shopping_basket),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10, left: 16),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.black, width: 1),
              color: Colors.white.withOpacity(.7),
            ),
            child: Center(
              child: Text("0"),
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }

  List lista = [
    CatalogoHome(),
    CategoriaList(),
    LojaList(),
    PromocaoList(),
    ProdutoList(),
  ];

  changeIndex(int index) {
    setState(() {
      elementIndex = index;
    });
  }
}
