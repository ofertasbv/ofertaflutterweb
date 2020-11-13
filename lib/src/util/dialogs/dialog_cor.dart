import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/cor_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/cor.dart';
import 'package:nosso/src/util/load/circular_progresso_mini.dart';

class DialogCor extends StatefulWidget {
  @override
  _DialogCorState createState() => _DialogCorState();
}

class _DialogCorState extends State<DialogCor> {
  var corController = GetIt.I.get<CorController>();
  var produtoController = GetIt.I.get<ProdutoController>();

  bool clicadoCor = false;

  @override
  void initState() {
    corController.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildObserverCores();
  }

  onSelectedCor(bool selected, Cor cor) {
    if (selected == true) {
      produtoController.addCores(cor);
    } else {
      produtoController.removerCores(cor);
    }
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
          value: produtoController.coresSelecionada.contains(cores[index]),
          onChanged: (bool select) {
            clicadoCor = select;
            onSelectedCor(clicadoCor, c);
            print("Clicado: ${clicadoCor} - ${c.descricao}");
            for (Cor c in produtoController.coresSelecionada) {
              print("Lista: ${c.descricao}");
            }
          },
          title: Text("${c.descricao}"),
        );
      },
    );
  }
}
