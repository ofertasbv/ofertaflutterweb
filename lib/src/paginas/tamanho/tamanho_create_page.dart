import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/marca_controller.dart';
import 'package:nosso/src/core/controller/tamanho_controller.dart';
import 'package:nosso/src/core/model/marca.dart';
import 'package:nosso/src/core/model/tamanho.dart';
import 'package:nosso/src/paginas/marca/marca_page.dart';
import 'package:nosso/src/paginas/tamanho/tamanho_page.dart';

class TamanhoCreatePage extends StatefulWidget {
  Tamanho tamanho;

  TamanhoCreatePage({Key key, this.tamanho}) : super(key: key);

  @override
  _TamanhoCreatePageState createState() => _TamanhoCreatePageState(c: tamanho);
}

class _TamanhoCreatePageState extends State<TamanhoCreatePage> {
  TamanhoController tamanhoController = GetIt.I.get<TamanhoController>();

  Tamanho c;
  File file;
  bool isButtonDesable = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _TamanhoCreatePageState({this.c});

  var controllerNome = TextEditingController();

  @override
  void initState() {
    tamanhoController.getAll();
    if (c == null) {
      c = Tamanho();
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
        title: Text("Tamanhos cadastros"),
      ),
      body: Observer(
        builder: (context) {
          if (tamanhoController.error != null) {
            return Text("Não foi possível cadastrar tamanho");
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
                                  initialValue: c.descricao,
                                  onSaved: (value) => c.descricao = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Descrição",
                                    hintText: "descrição do tamanho",
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
                              tamanhoController.create(c);
                              showToast("Cadastro  realizado com sucesso");
                              Navigator.of(context).pop();
                              buildPush(context);
                            });
                          } else {
                            Timer(Duration(seconds: 3), () {
                              tamanhoController.update(c.id, c);
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
        builder: (context) => TamanhoPage(),
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