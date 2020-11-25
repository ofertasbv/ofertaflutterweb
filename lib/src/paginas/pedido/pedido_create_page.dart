import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/pedido_controller.dart';
import 'package:nosso/src/core/controller/permissao_controller.dart';
import 'package:nosso/src/core/model/pedido.dart';
import 'package:nosso/src/core/model/permissao.dart';
import 'package:nosso/src/paginas/permissao/permissao_page.dart';
import 'package:nosso/src/util/dialogs/dialogs.dart';

class PedidoCreatePage extends StatefulWidget {
  Pedido pedido;

  PedidoCreatePage({Key key, this.pedido}) : super(key: key);

  @override
  _PedidoCreatePageState createState() =>
      _PedidoCreatePageState(p: this.pedido);
}

class _PedidoCreatePageState extends State<PedidoCreatePage> {
  var pedidoController = GetIt.I.get<PedidoController>();

  Dialogs dialogs = Dialogs();

  Pedido p;
  File file;

  _PedidoCreatePageState({this.p});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  var controllerNome = TextEditingController();

  @override
  void initState() {
    pedidoController.getAll();
    if (p == null) {
      p = Pedido();
    }
    super.initState();
  }

  Controller controller;

  @override
  void didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  showToast(String cardTitle) {
    Fluttertoast.showToast(
      msg: "$cardTitle",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 10,
      fontSize: 16.0,
    );
  }

  showSnackbar(BuildContext context, String content) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Pedido cadastros"),
      ),
      body: Observer(
        builder: (context) {
          if (pedidoController.dioError == null) {
            return buildListViewForm(context);
          } else {
            print("Erro: ${pedidoController.mensagem}");
            showToast("${pedidoController.mensagem}");
            return buildListViewForm(context);
          }
        },
      ),
    );
  }

  buildListViewForm(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: p.descricao,
                          onSaved: (value) => p.descricao = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Descrição",
                            hintText: "exe: CADASTRO_ROLE",
                            prefixIcon: Icon(Icons.edit, color: Colors.grey),
                            suffixIcon: Icon(Icons.close),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lime[900]),
                              gapPadding: 1,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 50,
                          maxLines: 1,
                          //initialValue: c.nome,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        RaisedButton.icon(
          label: Text("Enviar formulário"),
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          onPressed: () {
            if (controller.validate()) {
              if (p.id == null) {
                dialogs.information(context, "prepando para o cadastro...");
                Timer(Duration(seconds: 3), () {
                  pedidoController.create(p);
                  Navigator.of(context).pop();
                  buildPush(context);
                });
              } else {
                dialogs.information(context, "preparando para o alteração...");
                Timer(Duration(seconds: 3), () {
                  pedidoController.update(p.id, p);
                  Navigator.of(context).pop();
                  buildPush(context);
                });
              }
            }
          },
        ),
      ],
    );
  }

  buildPush(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PermissaoPage(),
      ),
    );
  }
}

class Controller {
  var formKey = GlobalKey<FormState>();

  bool validate() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else
      return false;
  }
}
