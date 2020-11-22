import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/arquivo_controller.dart';
import 'package:nosso/src/core/model/arquivo.dart';
import 'package:nosso/src/core/model/uploadFileResponse.dart';
import 'package:nosso/src/paginas/arquivo/arquivo_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nosso/src/util/dialogs/dialogs.dart';
import 'package:nosso/src/util/upload/upload_response.dart';

class ArquivoCreatePage extends StatefulWidget {
  Arquivo arquivo;

  ArquivoCreatePage({Key key, this.arquivo}) : super(key: key);

  @override
  _ArquivoCreatePageState createState() => _ArquivoCreatePageState(a: arquivo);
}

class _ArquivoCreatePageState extends State<ArquivoCreatePage> {
  var arquivoController = GetIt.I.get<ArquivoController>();
  Dialogs dialogs = Dialogs();

  Arquivo a;
  File file;
  bool isButtonDesable = false;

  var uploadFileResponse = UploadFileResponse();
  var response = UploadRespnse();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _ArquivoCreatePageState({this.a});

  var controllerNome = TextEditingController();

  @override
  void initState() {
    arquivoController.getAll();
    if (a == null) {
      a = Arquivo();
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
      });
    }
  }

  onClickUpload() async {
    if (file != null) {
      var url = await arquivoController.upload(file, a.foto);

      print("url: ${url}");

      print("========= UPLOAD FILE RESPONSE ========= ");

      uploadFileResponse = response.response(uploadFileResponse, url);

      print("fileName: ${uploadFileResponse.fileName}");
      print("fileDownloadUri: ${uploadFileResponse.fileDownloadUri}");
      print("fileType: ${uploadFileResponse.fileType}");
      print("size: ${uploadFileResponse.size}");

      a.foto = uploadFileResponse.fileName;

      setState(() {
        uploadFileResponse;
      });

      showSnackbar(context, "Arquivo anexada com sucesso!");
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
        title: Text("Arquivos cadastros"),
      ),
      body: Observer(
        builder: (context) {
          if (arquivoController.dioError == null) {
            return buildListViewForm(context);
          } else {
            print("Erro: ${arquivoController.mensagem}");
            showToast("${arquivoController.mensagem}");
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
          color: Colors.grey[300],
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    onTap: () {
                      openBottomSheet(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            file != null
                                ? Image.file(
                                    file,
                                    fit: BoxFit.fitWidth,
                                    width: double.infinity,
                                    height: 300,
                                  )
                                : a.foto != null
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                          ConstantApi.urlArquivoArquivo +
                                              a.foto,
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
                Divider(),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                              child: Icon(Icons.delete_forever),
                              shape: new CircleBorder(),
                              onPressed: isEnabledDelete
                                  ? () => arquivoController.deleteFoto(a.foto)
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
              ],
            ),
          ),
        ),
        ExpansionTile(
          leading: Icon(Icons.photo),
          title: Text("Descrição"),
          children: [
            Container(
              height: 400,
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: ListTile(
                      title: Text("fileName"),
                      subtitle: Text("${uploadFileResponse.fileName}"),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: Text("fileDownloadUri"),
                      subtitle: Text("${uploadFileResponse.fileDownloadUri}"),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: Text("fileType"),
                      subtitle: Text("${uploadFileResponse.fileType}"),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: Text("size"),
                      subtitle: Text("${uploadFileResponse.size}"),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
              if (a.foto == null) {
                openBottomSheet(context);
              } else {
                if (a.id == null) {
                  dialogs.information(context, "prepando para o cadastro...");
                  Timer(Duration(seconds: 3), () {
                    print("Foto : ${a.foto}");

                    arquivoController.create(a);
                    Navigator.of(context).pop();
                    buildPush(context);
                  });
                } else {
                  dialogs.information(
                      context, "preparando para o alteração...");
                  Timer(Duration(seconds: 3), () {
                    print("Foto : ${a.foto}");

                    arquivoController.update(a.id, a);
                    Navigator.of(context).pop();
                    buildPush(context);
                  });
                }
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
