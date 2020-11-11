import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/cor_controller.dart';
import 'package:nosso/src/core/model/cor.dart';
import 'package:nosso/src/util/load/circular_progresso_mini.dart';

class DialogCor extends StatefulWidget {
  @override
  _DialogCorState createState() => _DialogCorState();
}

class _DialogCorState extends State<DialogCor> {
  CorController corController = GetIt.I.get<CorController>();
  List<Cor> corSelecionada = List();

  bool clicadoCor = false;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  onSelectedCor(bool selected, Cor cor) {
    if (selected == true) {
      setState(() {
        corSelecionada.add(cor);
      });
    } else {
      setState(() {
        corSelecionada.remove(cor);
      });
    }
  }

  alertSelectCor(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: buildObserverCores(),
          ),
        );
      },
    );
  }

  buildObserverCores() {
    return Observer(
      builder: (context) {
        List<Cor> cores = corController.cores;
        if (corController.error != null) {
          return Text("Não foi possível carregados dados");
        }

        if (cores == null) {
          return CircularProgressorMini();
        }

        return builderListCor(cores);
      },
    );
  }

  builderListCor(List<Cor> cores) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.separated(
      itemCount: cores.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        Cor c = cores[index];

        return CheckboxListTile(
          value: corSelecionada.contains(cores[index]),
          onChanged: (bool select) {
            clicadoCor = select;
            onSelectedCor(clicadoCor, c);
            print("Clicado: ${clicadoCor} - ${c.descricao}");
            for (Cor c in corSelecionada) {
              print("Lista: ${c.descricao}");
            }
          },
          title: Text("${c.descricao}"),
        );
      },
    );
  }
}
