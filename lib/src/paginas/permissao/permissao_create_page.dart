import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/permissao_controller.dart';
import 'package:nosso/src/core/model/permissao.dart';
import 'package:nosso/src/paginas/permissao/permissao_page.dart';

class PermissaoCreatePage extends StatefulWidget {
  Permissao permissao;

  PermissaoCreatePage({Key key, this.permissao}) : super(key: key);

  @override
  _PermissaoCreatePageState createState() =>
      _PermissaoCreatePageState(p: this.permissao);
}

class _PermissaoCreatePageState extends State<PermissaoCreatePage> {
  PermissaoController permissaoController = GetIt.I.get<PermissaoController>();

  Permissao p;
  File file;

  _PermissaoCreatePageState({this.p});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  var controllerNome = TextEditingController();

  @override
  void initState() {
    permissaoController.getAll();
    if (p == null) {
      p = Permissao();
    }
    super.initState();
  }

  Controller controller;

  @override
  void didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  showDefaultSnackbar(BuildContext context, String content) {
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
        title: Text("Permissão cadastros"),
      ),
      body: Observer(
        builder: (context) {
          if (permissaoController.error != null) {
            return Text("Não foi possível cadastrar permissao");
          } else {
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
                            labelText: "Nome",
                            hintText: "exe: CADASTRO_ROLE",
                            prefixIcon: Icon(Icons.edit),
                            suffixIcon: Icon(Icons.close),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
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
        Card(
          child: RaisedButton.icon(
            label: Text("Enviar formulário"),
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              if (controller.validate()) {
                if (p.id == null) {
                  Timer(Duration(seconds: 3), () {
                    permissaoController.create(p);
                    showDefaultSnackbar(
                        context, "Cadastro realizado com sucesso");
                    Navigator.of(context).pop();
                    buildPush(context);
                  });
                } else {
                  Timer(Duration(seconds: 3), () {
                    permissaoController.update(p.id, p);
                    showDefaultSnackbar(
                        context, "Cadastro alterado com sucesso");
                    Navigator.of(context).pop();
                    buildPush(context);
                  });
                }
              }
            },
          ),
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
