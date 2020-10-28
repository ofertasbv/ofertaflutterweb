import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  bool isEnabledEnviar = false;
  bool isEnabledDelete = false;

  enableButton() {
    setState(() {
      isEnabledEnviar = true;
    });
  }

  disableButton() {
    setState(() {
      isEnabledDelete = true;
    });
  }

  getFromGallery() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (f == null) {
      return;
    } else {
      var atual = DateTime.now();
      setState(() {
        this.file = f;
        String arquivo = file.path.split('/').last;
        String filePath = arquivo.replaceAll(
            "$arquivo", "produto-" + atual.toString() + ".png");
        print("arquivo: $arquivo");
        print("filePath: $filePath");
        c.foto = filePath;
      });
    }
  }

  getFromCamera() async {
    File f = await ImagePicker.pickImage(source: ImageSource.camera);

    if (f == null) {
      return;
    } else {
      var atual = DateTime.now();
      setState(() {
        this.file = f;
        String arquivo = file.path.split('/').last;
        String filePath = arquivo.replaceAll(
            "$arquivo", "promocao-" + atual.toString() + ".png");
        print("arquivo: $arquivo");
        print("filePath: $filePath");
        c.foto = filePath;
      });
    }
  }

  onClickUpload() async {
    if (file != null) {
      var url = await CategoriaRepository.upload(file, c.foto);
      print(" URL : $url");
      disableButton();
    }
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
              title: Text("Galeria"),
              onTap: () {
                enableButton();
                getFromGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined),
              title: Text("Camera"),
              onTap: () {
                enableButton();
                getFromCamera();
              },
            ),
          ],
        );
      },
    );
  }

  showToast(String cardTitle) {
    Fluttertoast.showToast(
      msg: "$cardTitle",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.indigo,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Categoria cadastros"),
      ),
      body: Observer(
        builder: (context) {
          if (categoriaController.error != null) {
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
                                  //initialValue: c.nome,
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      RaisedButton(
                                        child: Icon(Icons.delete_forever),
                                        shape: new CircleBorder(),
                                        onPressed: isEnabledDelete
                                            ? () => categoriaController
                                                .deleteFoto(c.foto)
                                            : null,
                                      ),
                                      RaisedButton(
                                        child: Icon(Icons.photo),
                                        shape: new CircleBorder(),
                                        onPressed: () {
                                          openBottomSheet(context);
                                        },
                                      ),
                                      RaisedButton(
                                        child: Icon(Icons.check),
                                        shape: new CircleBorder(),
                                        onPressed: isEnabledEnviar
                                            ? () => onClickUpload()
                                            : null,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: GestureDetector(
                            onTap: () {
                              openBottomSheet(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    file != null
                                        ? Image.file(
                                            file,
                                            fit: BoxFit.fitWidth,
                                          )
                                        : c.foto != null
                                            ? CircleAvatar(
                                                radius: 50,
                                                backgroundImage: NetworkImage(
                                                  ConstantApi
                                                          .urlArquivoCategoria +
                                                      c.foto,
                                                ),
                                              )
                                            : CircleAvatar(
                                                radius: 50,
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                ),
                                              ),
                                  ],
                                ),
                              ),
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
                        if (c.id == null) {
                          Timer(Duration(seconds: 3), () {
                            onClickUpload();
                            categoriaController.create(c);
                            showToast("Cadastro  realizado com sucesso");
                            Navigator.of(context).pop();
                            buildPush(context);
                          });
                        } else {
                          Timer(Duration(seconds: 3), () {
                            onClickUpload();
                            categoriaController.update(c.id, c);
                            showToast("Cadastro  alterado com sucesso");
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
        },
      ),
    );
  }

  buildPush(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoriaPage(),
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
