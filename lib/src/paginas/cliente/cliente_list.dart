import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/cliente_controller.dart';
import 'package:nosso/src/core/model/cliente.dart';
import 'package:nosso/src/paginas/cliente/cliente_create_page.dart';
import 'package:nosso/src/util/load/circular_progresso.dart';

class ClienteList extends StatefulWidget {
  @override
  _ClienteListState createState() => _ClienteListState();
}

class _ClienteListState extends State<ClienteList>
    with AutomaticKeepAliveClientMixin<ClienteList> {
  ClienteController clienteController = GetIt.I.get<ClienteController>();

  @override
  void initState() {
    clienteController.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return clienteController.getAll();
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
          List<Cliente> clientes = clienteController.clientes;
          if (clienteController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (clientes == null) {
            return CircularProgressor();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(clientes),
          );
        },
      ),
    );
  }

  ListView builderList(List<Cliente> clientes) {
    double containerWidth = 160;
    double containerHeight = 30;

    return ListView.builder(
      itemCount: clientes.length,
      itemBuilder: (context, index) {
        Cliente p = clientes[index];

        return GestureDetector(
          child: Card(
            child: ListTile(
              isThreeLine: true,
              leading: Container(
                color: Colors.grey[100],
                child: Image.network(
                  ConstantApi.urlArquivoCliente + p.foto,
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
              ),
              title: Text(p.nome),
              subtitle: Text("${p.endereco.logradouro}, ${p.endereco.numero}"),
              trailing: Container(
                height: 80,
                width: 50,
                child: buildPopupMenuButton(context, p),
              ),
            ),
          ),
          onTap: () {},
        );
      },
    );
  }

  PopupMenuButton<String> buildPopupMenuButton(
      BuildContext context, Cliente p) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert),
      onSelected: (valor) {
        if (valor == "novo") {
          print("novo");
        }

        if (valor == "editar") {
          print("editar");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ClienteCreatePage(
                  cliente: p,
                );
              },
            ),
          );
        }
        if (valor == "delete") {
          print("delete");
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'novo',
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('novo'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'editar',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('editar'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('delete'),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
