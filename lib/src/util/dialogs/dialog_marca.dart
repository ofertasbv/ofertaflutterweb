import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/marca_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/marca.dart';
import 'package:nosso/src/util/load/circular_progresso_mini.dart';

class DialogMarca extends StatefulWidget {
  Marca marca;
  DialogMarca(this.marca);

  @override
  _DialogMarcaState createState() => _DialogMarcaState(this.marca);
}

class _DialogMarcaState extends State<DialogMarca> {
  _DialogMarcaState(this.marca);

  MarcaController marcaController = GetIt.I.get<MarcaController>();
  ProdutoController produtoController = GetIt.I.get<ProdutoController>();

  AlertMarca alertMarca = AlertMarca();

  Marca marca;

  @override
  void initState() {
    marcaController.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return builderConteudoListMarca();
  }

  builderConteudoListMarca() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Marca> marcas = marcaController.marcas;
          if (marcaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (marcas == null) {
            return CircularProgressorMini();
          }

          return builderListMarcas(marcas);
        },
      ),
    );
  }

  builderListMarcas(List<Marca> marcas) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.builder(
      itemCount: marcas.length,
      itemBuilder: (context, index) {
        Marca c = marcas[index];

        return Column(
          children: [
            GestureDetector(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.shopping_bag_outlined),
                ),
                title: Text(c.nome),
              ),
              onTap: () {
                produtoController.marcaSelecionada = c;
                print("Marca: ${produtoController.marcaSelecionada.nome}");
                Navigator.of(context).pop();
              },
            ),
            Divider()
          ],
        );
      },
    );
  }
}

class AlertMarca {
  alert(BuildContext context, Marca marca) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: DialogMarca(marca),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("ok"),
            )
          ],
        );
      },
    );
  }
}
