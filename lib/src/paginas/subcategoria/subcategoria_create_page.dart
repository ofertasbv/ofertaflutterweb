import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/categoria_controller.dart';
import 'package:nosso/src/core/controller/subcategoria_controller.dart';
import 'package:nosso/src/core/model/categoria.dart';
import 'package:nosso/src/core/model/subcategoria.dart';
import 'package:nosso/src/core/repository/subcategoria_repository.dart';
import 'package:nosso/src/paginas/categoria/categoria_dialog.dart';
import 'package:nosso/src/paginas/subcategoria/subcategoria_page.dart';

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
      timeInSecForIos: 1,
      fontSize: 16.0,
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
          if (categoriaController.error != null) {
            return Text("Não foi possível cadastrar subcategoria");
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
                                  initialValue: s.nome,
                                  onSaved: (value) => s.nome = value,
                                  validator: (value) => value.isEmpty
                                      ? "campo obrigatório"
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: "Nome",
                                    hintText: "nome subcategoria",
                                    prefixIcon: Icon(Icons.edit),
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
                                  alertSelectCategorias(
                                      context, categoriaSelecionada);
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
                        openAlertBox(context, s);
                      }
                    },
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
        builder: (context) => SubcategoriaPage(),
      ),
    );
  }

  openAlertBox(BuildContext context, SubCategoria c) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Detalhes de categoria",
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.star_border,
                          size: 30.0,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(
                  color: Colors.grey,
                  height: 4.0,
                ),
                Container(
                  child: ListTile(
                    title: Text("Nome"),
                    subtitle: Text("${c.nome}"),
                  ),
                ),
                SizedBox(height: 5),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32.0),
                        bottomRight: Radius.circular(32.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          color: Colors.blueGrey[900],
                          child: const Text('CANCELAR'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          color: Colors.indigo[900],
                          child: const Text('CONFIRMAR'),
                          onPressed: () {
                            if (c.id == null) {
                              Timer(Duration(seconds: 3), () {
                                s.categoria = categoriaSelecionada;
                                subCategoriaController.create(s);
                                showToast("Cadastro  realizado com sucesso");
                                Navigator.of(context).pop();
                                buildPush(context);
                              });
                            } else {
                              Timer(Duration(seconds: 3), () {
                                s.categoria = categoriaSelecionada;
                                subCategoriaController.update(c.id, c);
                                showToast("Cadastro  alterado com sucesso");
                                Navigator.of(context).pop();
                                buildPush(context);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  alertSelectCategorias(BuildContext context, Categoria c) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: builderConteudoList(),
          ),
        );
      },
    );
  }

  builderConteudoList() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Categoria> categorias = categoriaController.categorias;
          if (categoriaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (categorias == null) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.indigo[900],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            );
          }

          return builderListCategorias(categorias);
        },
      ),
    );
  }

  builderListCategorias(List<Categoria> categorias) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        Categoria c = categorias[index];

        return Column(
          children: [
            GestureDetector(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "${ConstantApi.urlArquivoCategoria + c.foto}",
                  ),
                ),
                title: Text(c.nome),
              ),
              onTap: () {
                setState(() {
                  categoriaSelecionada = c;
                  print("${categoriaSelecionada.nome}");
                });
                Navigator.of(context).pop();
              },
            ),
            Divider()
          ],
        );
      },
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
