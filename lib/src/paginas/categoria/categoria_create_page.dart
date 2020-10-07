import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/categoria_controller.dart';
import 'package:nosso/src/core/model/categoria.dart';
import 'package:nosso/src/core/repository/categoria_repository.dart';
import 'package:nosso/src/paginas/categoria/categoria_page.dart';
import 'package:image_picker/image_picker.dart';

class CategoriaCreatePage extends StatefulWidget {
  Categoria categoria;

  CategoriaCreatePage({Key key, this.categoria}) : super(key: key);

  @override
  _CategoriaCreatePageState createState() =>
      _CategoriaCreatePageState(c: categoria);
}

class _CategoriaCreatePageState extends State<CategoriaCreatePage> {
  CategoriaController categoriaController = GetIt.I.get<CategoriaController>();

  Categoria c;
  File file;
  bool isButtonDesable = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _CategoriaCreatePageState({this.c});

  var controllerNome = TextEditingController();

  @override
  void initState() {
    categoriaController.getAll();
    if (c == null) {
      c = Categoria();
    }
    super.initState();
  }

  Controller controller;

  @override
  didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  onClickFoto() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);
    var atual = DateTime.now();
    setState(() {
      this.file = f;
      String arquivo = file.path.split('/').last;
      String filePath = arquivo.replaceAll(
          "$arquivo", "categoria-" + atual.toString() + ".png");
      print("arquivo: $arquivo");
      print("filePath: $filePath");
      c.foto = filePath;
    });
  }

  onClickUpload() async {
    if (file != null) {
      var url = await CategoriaRepository.upload(file, c.foto);
      print(" URL : $url");
    }
  }

  void showDefaultSnackbar(BuildContext context, String content) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.pink[900],
        content: Text(content),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
        ),
      ),
    );
  }

  void showToast(String cardTitle) {
    Fluttertoast.showToast(
      msg: "$cardTitle",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.indigo,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo),
              title: Text("Photos"),
              onTap: () {
                onClickFoto();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text("Camera"),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categoria cadastros"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_upload,
            ),
            onPressed: () {
              onClickFoto();
            },
          )
        ],
      ),
      body: Observer(
        builder: (context) {
          if (categoriaController.error != null) {
            return Text("Não foi possível cadastrar categoria");
          } else {
            return ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
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
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                  maxLines: 2,
                                  //initialValue: c.nome,
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RaisedButton(
                                      child: Icon(Icons.delete_forever),
                                      shape: new CircleBorder(),
                                      onPressed: () {
                                        categoriaController.deleteFoto(c.foto);
                                      },
                                    ),
                                    RaisedButton(
                                      child: Icon(Icons.photo),
                                      shape: new CircleBorder(),
                                      onPressed: () {
                                        openBottomSheet(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    file != null
                                        ? Image.file(file,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.fill)
                                        : Image.asset(
                                            ConstantApi.urlUpload,
                                            height: 100,
                                            width: 100,
                                          ),
                                    SizedBox(height: 15),
                                    c.foto != null
                                        ? Text("${c.foto}")
                                        : Text("sem arquivo"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    label: Text(
                      "Enviar formulário",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    textColor: Colors.white,
                    splashColor: Colors.red,
                    color: Colors.black,
                    onPressed: () {
                      if (controller.validate()) {
                        if (c.foto == null) {
                          showToast("deve anexar uma foto!");
                        } else {
                          onClickUpload();
                          categoriaController.create(c);

                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoriaPage(),
                            ),
                          );
                        }
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
