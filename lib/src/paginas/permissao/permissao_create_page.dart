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

  void showDefaultSnackbar(BuildContext context, String content) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
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
      appBar: AppBar(
        title: Text("Permissão cadastros"),
      ),
      body: Observer(
        builder: (context) {
          if (permissaoController.errorMessage != null) {
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
            autovalidateMode: AutovalidateMode.always,
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
        buildContainerButton(context),
      ],
    );
  }

  buildContainerButton(BuildContext context) {
    return Card(
      child: RaisedButton.icon(
        label: Text("Enviar formulário"),
        icon: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          enviarFormulario(context);
        },
      ),
    );
  }

  enviarFormulario(BuildContext context) {
    if (controller.validate()) {
      permissaoController.create(p);
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return PermissaoPage();
        },
      ));
    }
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
