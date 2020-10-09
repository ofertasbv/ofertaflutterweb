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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SubCategoriaController subCategoriaController =
      GetIt.I.get<SubCategoriaController>();
  CategoriaController categoriaController = GetIt.I.get<CategoriaController>();

  Future<List<Categoria>> categorias;

  SubCategoria s;
  Categoria categoriaSelecionada;
  Categoria categoriaSelect = Categoria();

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
    super.initState();
  }

  @override
  void didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
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
      //print(" upload de arquivo : ${s.foto}");
    });
  }

  onClickUpload() async {
    if (file != null) {
      var url = await SubCategoriaRepository.upload(file, s.foto);
    }
  }

  showDefaultSnackbar(BuildContext context, String content) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(content),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
        ),
      ),
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
    s.categoria = categoriaSelecionada;

    return Scaffold(
      key: _scaffoldKey,
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
          List<Categoria> lista = categoriaController.categorias;
          if (categoriaController.error != null) {
            return Text("Não foi possível cadastrar subcategoria");
          } else {
            return ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(2),
                  child: Form(
                    key: controller.formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  initialValue: s.nome,
                                  onSaved: (value) => s.nome = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
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
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                FutureBuilder<List<Categoria>>(
                                  future: categorias,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return DropdownButtonFormField<Categoria>(
                                        validator: (value) => value == null
                                            ? 'selecione uma categoria'
                                            : null,
                                        value: categoriaSelecionada,
                                        items: snapshot.data.map((categoria) {
                                          return DropdownMenuItem<Categoria>(
                                            value: categoria,
                                            child: Text(categoria.nome),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        hint: Text("Selecione categoria..."),
                                        onChanged: (Categoria c) {
                                          setState(() {
                                            categoriaSelecionada = c;
                                            print(categoriaSelecionada.nome);
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
                        Card(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("vá para galeria do seu aparelho..."),
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
                                    s.foto != null
                                        ? Text("${s.foto}")
                                        : Text("sem arquivo"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
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
                      "Enviar",
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
                        if (s.foto == null) {
                          showToast("deve anexar uma foto!");
                        } else {
                          onClickUpload();
                          subCategoriaController.create(s);

                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SubcategoriaPage();
                              },
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
