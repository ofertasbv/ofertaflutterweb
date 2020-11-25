import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/core/controller/loja_controller.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/core/model/promocao.dart';

class LojaDetalhesView extends StatefulWidget {
  Loja p;

  LojaDetalhesView(this.p);

  @override
  _LojaDetalhesViewState createState() => _LojaDetalhesViewState();
}

class _LojaDetalhesViewState extends State<LojaDetalhesView> {
  var selectedCard = 'WEIGHT';
  var lojaController = GetIt.I.get<LojaController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Loja p = widget.p;

    return buildContainer(p);
  }

  buildContainer(Loja p) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return ListView(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            lojaController.arquivo + p.foto,
            fit: BoxFit.cover,
          ),
        ),
        Card(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ListTile(
                  title: Text(
                    p.nome,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Text(
                    "Cel. ${p.telefone}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
