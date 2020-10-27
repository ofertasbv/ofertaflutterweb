import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/marca_controller.dart';
import 'package:nosso/src/core/model/marca.dart';
import 'package:nosso/src/paginas/marca/marca_page.dart';

class MarcaCreatePage extends StatefulWidget {
  Marca marca;

  MarcaCreatePage({Key key, this.marca}) : super(key: key);

  @override
  _MarcaCreatePageState createState() => _MarcaCreatePageState(c: marca);
}

class _MarcaCreatePageState extends State<MarcaCreatePage> {
  MarcaController marcaController = GetIt.I.get<MarcaController>();

  Marca c;
  File file;
  bool isButtonDesable = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _MarcaCreatePageState({this.c});

  var controllerNome = TextEditingController();

  @override
  void initState() {
    marcaController.getAll();
    if (c == null) {
      c = Marca();
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
      timeInSecForIos: 1,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Marcas cadastros"),
      ),
      body: Observer(
        builder: (context) {
          if (marcaController.error != null) {
            return Text("Não foi possível cadastrar categoria");
          } else {
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
                                  initialValue: c.nome,
                                  onSaved: (value) => c.nome = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Nome",
                                    hintText: "nome categoria",
                                    prefixIcon: Icon(Icons.edit),
                                    suffixIcon: Icon(Icons.close),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
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
                Card(
                  child: Container(
                    child: RaisedButton.icon(
                      label: Text("Enviar formulário"),
                      icon: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (controller.validate()) {
                          if (c.id == null) {
                            Timer(Duration(seconds: 3), () {
                              marcaController.create(c);
                              showToast("Cadastro  realizado com sucesso");
                              Navigator.of(context).pop();
                              buildPush(context);
                            });
                          } else {
                            Timer(Duration(seconds: 3), () {
                              marcaController.update(c.id, c);
                              showToast("Cadastro  alterado com sucesso");
                              Navigator.of(context).pop();
                              buildPush(context);
                            });
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
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
