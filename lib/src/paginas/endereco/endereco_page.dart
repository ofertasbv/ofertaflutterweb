
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/endereco_controller.dart';
import 'package:nosso/src/paginas/endereco/endereco_create_page.dart';
import 'package:nosso/src/paginas/endereco/endereco_list.dart';

class EnderecoPage extends StatelessWidget {
  var enderecoController = GetIt.I.get<EnderecoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Endereços"),
        actions: <Widget>[
          Observer(
            builder: (context) {
              if (enderecoController.error != null) {
                return Text("Não foi possível carregar");
              }

              if (enderecoController.enderecos == null) {
                return Center(
                  child: Icon(Icons.warning_amber_outlined),
                );
              }

              return Chip(
                label: Text(
                  (enderecoController.enderecos.length ?? 0).toString(),
                ),
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: EnderecoList(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 8,
            height: 8,
          ),
          FloatingActionButton(
            elevation: 10,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EnderecoCreatePage();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
