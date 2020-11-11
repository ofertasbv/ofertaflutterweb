import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/tamanho_controller.dart';
import 'package:nosso/src/core/model/tamanho.dart';
import 'package:nosso/src/util/load/circular_progresso_mini.dart';

class DialogTamanho extends StatefulWidget {
  @override
  _DialogTamanhoState createState() => _DialogTamanhoState();
}

class _DialogTamanhoState extends State<DialogTamanho> {
  var tamanhoController = GetIt.I.get<TamanhoController>();
  List<Tamanho> tamanhoSelecionada = List();

  bool clicadoTamanho = false;

  @override
  void initState() {
    tamanhoController.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildObserverTamanhos();
  }

  onSelectedTamanho(bool selected, Tamanho tamanho) {
    if (selected == true) {
      setState(() {
        tamanhoSelecionada.add(tamanho);
      });
    } else {
      setState(() {
        tamanhoSelecionada.remove(tamanho);
      });
    }
  }

  buildObserverTamanhos() {
    return Observer(
      builder: (context) {
        List<Tamanho> tamanhos = tamanhoController.tamanhos;
        if (tamanhoController.error != null) {
          return Text("Não foi possível carregados dados");
        }

        if (tamanhos == null) {
          return CircularProgressorMini();
        }

        return builderList(tamanhos);
      },
    );
  }

  builderList(List<Tamanho> tamanhos) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.separated(
      itemCount: tamanhos.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        Tamanho c = tamanhos[index];

        return CheckboxListTile(
          value: tamanhoSelecionada.contains(tamanhos[index]),
          onChanged: (bool select) {
            clicadoTamanho = select;
            onSelectedTamanho(clicadoTamanho, c);
            print("Clicado: ${clicadoTamanho} - ${c.descricao}");
            for (Tamanho t in tamanhoSelecionada) {
              print("Lista: ${t.descricao}");
            }
          },
          title: Text("${c.descricao}"),
        );
      },
    );
  }
}
