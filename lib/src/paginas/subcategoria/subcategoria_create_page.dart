import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/categoria_controller.dart';
import 'package:nosso/src/core/controller/subcategoria_controller.dart';
import 'package:nosso/src/core/model/categoria.dart';
import 'package:nosso/src/core/model/subcategoria.dart';
import 'package:nosso/src/paginas/categoria/categoria_dialog.dart';
import 'package:nosso/src/paginas/subcategoria/subcategoria_page.dart';
import 'package:nosso/src/util/componets/dropdown_categoria.dart';
import 'package:nosso/src/util/dialogs/dialog_subcategoria.dart';
import 'package:nosso/src/util/dialogs/dialogs.dart';
import 'package:nosso/src/util/load/circular_progresso_mini.dart';

class SubCategoriaCreatePage extends StatefulWidget {
  SubCategoria subCategoria;

  SubCategoriaCreatePage({Key key, this.subCategoria}) : super(key: key);

  @override
  _SubCategoriaCreatePageState createState() =>
      _SubCategoriaCreatePageState(s: subCategoria);
}

class _SubCategoriaCreatePageState extends State<SubCategoriaCreatePage> {
  _SubCategoriaCreatePageState({this.s});

  var subCategoriaController = GetIt.I.get<SubCategoriaController>();
  var categoriaController = GetIt.I.get<CategoriaController>();

  Dialogs dialogs = Dialogs();

  SubCategoria s;
  Categoria categoriaSelecionada;
  File file;

  Controller controller;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (s == null) {
      s = SubCategoria();
    } else {
      categoriaSelecionada = s.categoria;
    }
    subCategoriaController.getAll();
    super.initState();
  }

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
        title: Text(
          "SubCategoria cadastros",
        ),
      ),
      body: Observer(
        builder: (context) {
          if (subCategoriaController.dioError == null) {
            return buildListViewForm(context);
          } else {
            print("Erro: ${subCategoriaController.mensagem}");
            showToast("${subCategoriaController.mensagem}");
            return buildListViewForm(context);
          }
        },
      ),
    );
  }

  ListView buildListViewForm(BuildContext context) {
    categoriaController.categoriaSelecionada = s.categoria;

    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: s.nome,
                          onSaved: (value) => s.nome = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigatório" : null,
                          decoration: InputDecoration(
                            labelText: "Nome",
                            hintText: "nome subcategoria",
                            prefixIcon: Icon(
                              Icons.edit,
                              color: Colors.grey,
                            ),
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
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 0),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropDownCategoria(categoriaSelecionada),
                      Observer(
                        builder: (context) {
                          if (categoriaController.categoriaSelecionada ==
                              null) {
                            return Container(
                              padding: EdgeInsets.only(left: 25),
                              child: Container(
                                child: categoriaController.mensagem == null
                                    ? Text(
                                        "*",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      )
                                    : Text(
                                        "${categoriaController.mensagem}",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                              ),
                            );
                          }
                          return Container(
                            padding: EdgeInsets.only(left: 25),
                            child: Container(
                              child: Icon(Icons.check_outlined,
                                  color: Colors.green),
                            ),
                          );
                        },
                      ),
                    ],
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
              if (s.id == null) {
                dialogs.information(context, "prepando para o cadastro...");
                Timer(Duration(seconds: 3), () {
                  s.categoria = categoriaController.categoriaSelecionada;
                  subCategoriaController.create(s);
                  Navigator.of(context).pop();
                  buildPush(context);
                });
              } else {
                dialogs.information(context, "preparando para o alteração...");
                Timer(Duration(seconds: 3), () {
                  s.categoria = categoriaController.categoriaSelecionada;
                  subCategoriaController.update(s.id, s);

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
        builder: (context) => SubcategoriaPage(),
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
