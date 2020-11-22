import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/paginas/loja/loja_page.dart';
import 'package:nosso/src/paginas/promocao/promocao_page.dart';

class LojaDetalhes extends StatefulWidget {
  Loja loja;

  LojaDetalhes({Key key, this.loja}) : super(key: key);

  @override
  _LojaDetalhesState createState() => _LojaDetalhesState(p: this.loja);
}

class _LojaDetalhesState extends State<LojaDetalhes> {
  Loja p;

  _LojaDetalhesState({this.p});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(p.nome),
      ),
      body: buildContainer(p),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  buildContainer(Loja p) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return ListView(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.2,
          child: Image.network(
            ConstantApi.urlArquivoLoja + p.foto,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 0),
        Card(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(p.nome),
                    SizedBox(height: 10),
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.redAccent,
                      child: IconButton(
                        icon: Icon(
                          Icons.location_city,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(p.telefone),
                    SizedBox(height: 10),
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.redAccent,
                      child: IconButton(
                        icon: Icon(
                          Icons.phone_forwarded,
                          color: Colors.greenAccent,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(),
        Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text("Endereço"),
                  subtitle: Text("${p.enderecos[0].logradouro}- ${p.enderecos[0].numero}"),
                  leading: Icon(Icons.local_convenience_store_outlined),
                ),

                ListTile(
                  title: Text("Resgistro"),
                  subtitle: Text("${dateFormat.format(p.dataRegistro)}"),
                  leading: Icon(Icons.calendar_today_outlined),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildBottomNavigationBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: RaisedButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0),
                side: BorderSide(color: Colors.transparent),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PromocaoPage();
                    },
                  ),
                );
              },
              color: Colors.black,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.list),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text("MAIS OFERTAS"),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: RaisedButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0),
                side: BorderSide(color: Colors.transparent),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return LojaPage();
                    },
                  ),
                );
              },
              color: Colors.orange[900],
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.shopping_basket),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text("MAIS LOJAS"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
