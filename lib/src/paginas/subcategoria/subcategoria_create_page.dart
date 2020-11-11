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
  SubCategoriaController subCategoriaController =
      GetIt.I.get<SubCategoriaController>();
  CategoriaController categoriaController = GetIt.I.get<CategoriaController>();

  Dialogs dialogs = Dialogs();

  Future<List<Categoria>> categorias;
  List<DropdownMenuItem<Categoria>> dropDownItems = [];

  SubCategoria s;
  Categoria categoriaSelecionada;

  Controller controller;

  File file;

  _SubCategoriaCreatePageState({this.s});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    categorias = categoriaController.getAll();
    if (s == null) {
      s = SubCategoria();
      subCategoriaController.getAll();
    }
    categoriaSelecionada = s.categoria;
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
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: ListTile(
                        title: Text("Categoria *"),
                        subtitle: categoriaSelecionada == null
                            ? Text("Selecione uma categoria")
                            : Text(categoriaSelecionada.nome),
                        leading: Icon(Icons.list_alt_outlined),
                        trailing: Icon(Icons.arrow_drop_down_sharp),
                        onTap: () {
                          CategoriaDialog();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 0),
        Card(
          child: RaisedButton.icon(
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
                    s.categoria = categoriaSelecionada;
                    subCategoriaController.create(s);
                    Navigator.of(context).pop();
                    buildPush(context);
                  });
                } else {
                  dialogs.information(
                      context, "preparando para o alteração...");
                  Timer(Duration(seconds: 1), () {
                    s.categoria = categoriaSelecionada;
                    subCategoriaController.update(s.id, s);

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
