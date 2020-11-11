import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/promocao.dart';
import 'package:nosso/src/util/dialogs/dialog_promocao.dart';

class DropDownPromocao extends StatelessWidget {
  Promocao promocao;

  DropDownPromocao(this.promocao);

  @override
  Widget build(BuildContext context) {
    ProdutoController produtoController = GetIt.I.get<ProdutoController>();
    AlertPromocao alertPromocao = AlertPromocao();

    return Observer(
      builder: (context) {
        Promocao promocao = produtoController.promocaoSelecionada;

        return Card(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                title: Text("Promocao *"),
                subtitle: promocao == null
                    ? Text("Selecione uma promocao")
                    : Text(promocao.nome),
                leading: Icon(Icons.list_alt_outlined),
                trailing: Icon(Icons.arrow_drop_down_sharp),
                onTap: () {
                  alertPromocao.alert(context, promocao);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
