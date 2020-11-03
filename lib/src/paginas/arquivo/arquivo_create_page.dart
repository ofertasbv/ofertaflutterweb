import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/arquivo_controller.dart';
import 'package:nosso/src/core/model/arquivo.dart';
import 'package:nosso/src/paginas/arquivo/arquivo_page.dart';
import 'package:image_picker/image_picker.dart';

class ArquivoCreatePage extends StatefulWidget {
  Arquivo arquivo;

  ArquivoCreatePage({Key key, this.arquivo}) : super(key: key);

  @override
  _ArquivoCreatePageState createState() => _ArquivoCreatePageState(c: arquivo);
}

class _ArquivoCreatePageState extends State<ArquivoCreatePage> {
  ArquivoController arquivoController = GetIt.I.get<ArquivoController>();

  Arquivo c;
  File file;
  bool isButtonDesable = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _ArquivoCreatePageState({this.c});

  var controllerNome = TextEditingController();

  @override
  void initState() {
    arquivoController.getAll();
    if (c == null) {
      c = Arquivo();
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
      setState(() {
        this.file = f;
        String arquivo = file.path.split('/').last;
        print("filePath: $arquivo");
        c.foto = arquivo;
      });
    }
  }

  getFromCamera() async {
    File f = await ImagePicker.pickImage(source: ImageSource.camera);

    if (f == null) {
      return;
    } else {
      setState(() {
        this.file = f;
        String arquivo = file.path.split('/').last;
        print("filePath: $arquivo");
        c.foto = arquivo;
      });
    }
  }

  onClickUpload() async {
    if (file != null) {
      FormData url = await arquivoController.upload(file, c.foto);
      print("URL: ${url}");
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
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Arquivos cadastros"),
      ),
      body: Observer(
        builder: (context) {
          if (arquivoController.error != null) {
            return Text("Não foi possível cadastrar arquivo");
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
                                            ? () => arquivoController
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
                            arquivoController.create(c);
                            showToast("Cadastro  realizado com sucesso");
                            Navigator.of(context).pop();
                            buildPush(context);
                          });
                        } else {
                          Timer(Duration(seconds: 3), () {
                            onClickUpload();
                            arquivoController.update(c.id, c);
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
        builder: (context) => ArquivoPage(),
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
