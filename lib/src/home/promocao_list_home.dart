import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/promocao_controller.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/core/model/promocao.dart';
import 'package:nosso/src/paginas/promocao/promocao_detalhes.dart';
import 'package:nosso/src/util/load/circular_progresso_mini.dart';

class PromocaoListHome extends StatefulWidget {
  Loja p;

  PromocaoListHome({Key key, this.p}) : super(key: key);

  @override
  _PromocaoListHomeState createState() => _PromocaoListHomeState(p: this.p);
}

class _PromocaoListHomeState extends State<PromocaoListHome>
    with AutomaticKeepAliveClientMixin<PromocaoListHome> {
  var promocaoController = GetIt.I.get<PromoCaoController>();

  Loja p;

  _PromocaoListHomeState({this.p});

  @override
  void initState() {
    promocaoController.getAll();

    super.initState();
  }

  Future<void> onRefresh() {
    return promocaoController.getAll();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return builderConteudoList();
  }

  builderConteudoList() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Promocao> promocoes = promocaoController.promocoes;
          if (promocaoController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (promocoes == null) {
            return CircularProgressorMini();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(promocoes),
          );
        },
      ),
    );
  }

  ListView builderList(List<Promocao> promocoes) {
    double containerWidth = 350;
    double containerHeight = 50;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: promocoes.length,
      itemBuilder: (context, index) {
        Promocao p = promocoes[index];

        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedContainer(
              width: containerWidth,
              duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[200],
                    Colors.grey[200],
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200], width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.grey[200],
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                      ),
                      child: Image.network(
                        promocaoController.arquivo + p.foto,
                        fit: BoxFit.cover,
                        width: containerWidth,
                        height: 200,
                      ),
                    ),
                  ),
                  SizedBox(height: 0),
                  Container(
                      padding: EdgeInsets.all(2),
                      width: containerWidth,
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(
                          p.nome,
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(p.descricao),
                      )),
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PromocaoDetalhes(p);
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
