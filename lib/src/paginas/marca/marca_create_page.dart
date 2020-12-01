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
import 'package:nosso/src/util/dialogs/dialogs.dart';

class MarcaCreatePage extends StatefulWidget {
  Marca marca;

  MarcaCreatePage({Key key, this.marca}) : super(key: key);

  @override
  _MarcaCreatePageState createState() => _MarcaCreatePageState(c: marca);
}

class _MarcaCreatePageState extends State<MarcaCreatePage> {
  var marcaController = GetIt.I.get<MarcaController>();
  Dialogs dialogs = Dialogs();

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
        title: Text("Marcas cadastros"),
      ),
      body: Observer(
        builder: (context) {
          if (marcaController.dioError == null) {
            return buildListViewForm(context);
          } else {
            print("Erro: ${marcaController.mensagem}");
            showToast("${marcaController.mensagem}");
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
                Container(
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
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(10),
          child: RaisedButton.icon(
            label: Text("Enviar formulário"),
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              if (controller.validate()) {
                if (c.id == null) {
                  dialogs.information(context, "prepando para o cadastro...");
                  Timer(Duration(seconds: 3), () {
                    marcaController.create(c).then((arquivo) {
                      var resultado = arquivo;
                      print("resultado : ${resultado}");
                    });
                    Navigator.of(context).pop();
                    buildPush(context);
                  });
                } else {
                  dialogs.information(
                      context, "preparando para o alteração...");
                  Timer(Duration(seconds: 3), () {
                    marcaController.update(c.id, c);
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
