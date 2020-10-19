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
  Categoria categoriaSelect = Categoria();

  Controller controller;

  File file;

  _SubCategoriaCreatePageState({this.s});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didUpdateWidget(covariant SubCategoriaCreatePage oldWidget) {
    categoriaSelecionada = oldWidget.subCategoria.categoria;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    categorias = categoriaController.getAll();
    if (s == null) {
      s = SubCategoria();
      subCategoriaController.getAll();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
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

  onClickFoto() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);
    var dataAtual = DateTime.now();
    setState(() {
      this.file = f;
      String arquivo = file.path.split('/').last;
      String filePath = arquivo.replaceAll(
          "$arquivo", "subcategoria-" + dataAtual.toString() + ".png");
      print("arquivo: $arquivo");
      print("filePath: $filePath");
      s.foto = filePath;
    });
  }

  onClickUpload() async {
    if (file != null) {
      var url = await SubCategoriaRepository.upload(file, s.foto);
      print(" URL : $url");
      disableButton();
    }
  }

  showDefaultSnackbar(BuildContext context, String content) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Icon(Icons.photo_album),
        action: SnackBarAction(
          label: content,
          onPressed: () {
            enableButton();
            onClickFoto();
          },
        ),
      ),
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
    // print("Categoria: ${s.categoria.nome}");

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          "SubCategoria cadastros",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: onClickFoto,
          )
        ],
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
                    autovalidateMode: AutovalidateMode.always,
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
                        Card(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: <Widget>[
                                FutureBuilder<List<Categoria>>(
                                  future: categorias,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return DropdownButtonFormField<Categoria>(
                                        onSaved: (value) => s.categoria = value,
                                        validator: (value) => value == null
                                            ? 'campo obrigatório'
                                            : null,
                                        value: categoriaSelecionada,
                                        items: snapshot.data.map((categoria) {
                                          return DropdownMenuItem<Categoria>(
                                            value: categoria,
                                            child: Text(categoria.nome),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          labelText: "Categoria",
                                          filled: true,
                                          fillColor: Colors.white,
                                          prefixIcon: Icon(Icons.list_alt_outlined),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.white),
                                          ),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 20.0, 20.0, 20.0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(5.0)),
                                        ),
                                        onChanged: (Categoria c) {
                                          setState(() {
                                            categoriaSelecionada = c;
                                            s.categoria = c;
                                            // print(
                                            //     "Categoria Selecionada: ${categoriaSelecionada.nome}");
                                          });
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("${snapshot.error}");
                                    }

                                    return Text(
                                        "não foi peossível carregar categorias");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 0),
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
                                      onPressed: isEnabledDelete
                                          ? () => subCategoriaController
                                              .deleteFoto(s.foto)
                                          : null,
                                    ),
                                    RaisedButton(
                                      child: Icon(Icons.photo),
                                      shape: new CircleBorder(),
                                      onPressed: () {
                                        showDefaultSnackbar(context, "ir para galeria");
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
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Colors.grey[300],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    file != null
                                        ? Image.file(
                                            file,
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.fitWidth,
                                          )
                                        : s.foto != null
                                            ? Image.network(
                                                ConstantApi.urlArquivoSubCategoria +
                                                    s.foto,
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.fitWidth,
                                              )
                                            : Text("anexar arquivo"),
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
                SizedBox(height: 0),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton.icon(
                          label: Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        RaisedButton.icon(
                          label: Text(
                            "Cadastrar",
                            style: TextStyle(color: Colors.white),
                          ),
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
                      ],
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
                Container(
                  child: ListTile(
                    title: Text("Foto"),
                    subtitle: Text("${c.foto}"),
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
                                onClickUpload();
                                subCategoriaController.create(s);
                                showToast("Cadastro  realizado com sucesso");
                                Navigator.of(context).pop();
                                buildPush(context);
                              });
                            } else {
                              Timer(Duration(seconds: 3), () {
                                onClickUpload();
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
