import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/core/controller/promocao_controller.dart';
import 'package:nosso/src/core/model/promocao.dart';

class PromocaoDetalhesView extends StatefulWidget {
  Promocao p;

  PromocaoDetalhesView(this.p);

  @override
  _PromocaoDetalhesViewState createState() => _PromocaoDetalhesViewState();
}

class _PromocaoDetalhesViewState extends State<PromocaoDetalhesView> {
  var selectedCard = 'WEIGHT';
  var promocaoController = GetIt.I.get<PromoCaoController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Promocao p = widget.p;

    return buildContainer(p);
  }

  buildContainer(Promocao p) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return ListView(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            promocaoController.arquivo + p.foto,
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
                  subtitle: Text(
                    p.descricao,
                  ),
                  trailing: Text(
                    "OFF ${p.desconto} %",
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
