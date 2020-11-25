import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/usuario_controller.dart';
import 'package:nosso/src/core/model/usuario.dart';
import 'package:nosso/src/paginas/marca/marca_page.dart';
import 'package:nosso/src/util/dialogs/dialogs.dart';

class UsuarioCreatePage extends StatefulWidget {
  Usuario usuario;

  UsuarioCreatePage({Key key, this.usuario}) : super(key: key);

  @override
  _UsuarioCreatePageState createState() =>
      _UsuarioCreatePageState(u: this.usuario);
}

class _UsuarioCreatePageState extends State<UsuarioCreatePage> {
  var usuarioController = GetIt.I.get<UsuarioController>();
  Dialogs dialogs = Dialogs();

  Usuario u;
  File file;
  bool isButtonDesable = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _UsuarioCreatePageState({this.u});

  var controllerNome = TextEditingController();

  @override
  void initState() {
    usuarioController.getAll();
    if (u == null) {
      u = Usuario();
    }
    super.initState();
  }

  Controller controller;

  @override
  didChangeDependencies() {
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
      appBar: AppBar(
        title: Text("Usuário cadastros"),
      ),
      body: Observer(
        builder: (context) {
          if (usuarioController.dioError == null) {
            return buildListViewForm(context);
          } else {
            print("Erro: ${usuarioController.mensagem}");
            showToast("${usuarioController.mensagem}");
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
          padding: EdgeInsets.all(0),
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
                          initialValue: u.email,
                          onSaved: (value) => u.email = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "email@gmail.com",
                            prefixIcon: Icon(
                              Icons.edit,
                              color: Colors.grey,
                            ),
                            suffixIcon: Icon(Icons.close),
                            labelStyle: TextStyle(color: Colors.black),
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
                        ),
                        SizedBox(height: 10),
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
              if (u.id == null) {
                dialogs.information(context, "prepando para o cadastro...");
                Timer(Duration(seconds: 3), () {
                  usuarioController.create(u).then((arquivo) {
                    var resultado = arquivo;
                    print("resultado : ${resultado}");
                  });
                  Navigator.of(context).pop();
                  buildPush(context);
                });
              } else {
                dialogs.information(context, "preparando para o alteração...");
                Timer(Duration(seconds: 3), () {
                  usuarioController.update(u.id, u);
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
        builder: (context) => MarcaPage(),
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