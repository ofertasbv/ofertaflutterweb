import 'dart:async';
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/loja_controller.dart';
import 'package:nosso/src/core/model/endereco.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/core/model/usuario.dart';
import 'package:nosso/src/core/repository/loja_repository.dart';
import 'package:nosso/src/paginas/loja/loja_page.dart';
import 'package:nosso/src/util/dialogs/dialogs.dart';

class LojaCreatePage extends StatefulWidget {
  Loja loja;

  LojaCreatePage({Key key, this.loja}) : super(key: key);

  @override
  _LojaCreatePageState createState() => _LojaCreatePageState(p: this.loja);
}

class _LojaCreatePageState extends State<LojaCreatePage> {
  LojaController lojaController = GetIt.I.get<LojaController>();

  Dialogs dialogs = Dialogs();

  Loja p;
  Endereco e;
  Usuario u;

  _LojaCreatePageState({this.p});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime dataAtual = DateTime.now();
  String tipoPessoa;
  String valorSlecionado;
  File file;

  @override
  void initState() {
    if (p == null) {
      p = Loja();
      u = Usuario();
      e = Endereco();
    } else {
      u = p.usuario;
    }

    tipoPessoa = "JURIDICA";
    super.initState();
  }

  Controller controller;

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

  getFromGallery() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (f == null) {
      return;
    } else {
      setState(() {
        this.file = f;
        String arquivo = file.path.split('/').last;
        print("filePath: $arquivo");
        p.foto = arquivo;
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
        p.foto = arquivo;
      });
    }
  }

  onClickUpload() async {
    if (file != null) {
      FormData url = await lojaController.upload(file, p.foto);
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
        title: Text("Cadastro de loja"),
      ),
      body: Observer(
        builder: (context) {
          if (lojaController.dioError == null) {
            return buildListViewForm(context);
          } else {
            print("Erro: ${lojaController.mensagem}");
            showToast("${lojaController.mensagem}");
            return buildListViewForm(context);
          }
        },
      ),
    );
  }

  buildListViewForm(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    var maskFormatterCelular = new MaskTextInputFormatter(
        mask: '(##)#####-####', filter: {"#": RegExp(r'[0-9]')});

    var maskFormatterCNPJ = new MaskTextInputFormatter(
        mask: '##.###.###/###-##', filter: {"#": RegExp(r'[0-9]')});

    p.usuario = u;

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
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("PESSOA FISICA"),
                                value: "FISICA",
                                groupValue: p.tipoPessoa == null
                                    ? tipoPessoa
                                    : p.tipoPessoa,
                                onChanged: (String valor) {
                                  setState(() {
                                    p.tipoPessoa = valor;
                                    print("resultado: " + p.tipoPessoa);
                                  });
                                },
                              ),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("PESSOA JURIDICA"),
                                value: "JURIDICA",
                                groupValue: p.tipoPessoa == null
                                    ? tipoPessoa
                                    : p.tipoPessoa,
                                onChanged: (String valor) {
                                  setState(() {
                                    p.tipoPessoa = valor;
                                    print("resultado: " + p.tipoPessoa);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: p.nome,
                          onSaved: (value) => p.nome = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Nome",
                            hintText: "nome",
                            prefixIcon: Icon(Icons.people, color: Colors.grey),
                            suffixIcon: Icon(Icons.close),
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
                        ),
                        TextFormField(
                          initialValue: p.razaoSocial,
                          onSaved: (value) => p.razaoSocial = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Razão social ",
                            hintText: "razão social",
                            prefixIcon: Icon(Icons.people, color: Colors.grey),
                            suffixIcon: Icon(Icons.close),
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
                        ),
                        TextFormField(
                          initialValue: p.cnpj,
                          onSaved: (value) => p.cnpj = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Cnpj",
                            hintText: "Cnpj",
                            prefixIcon:
                                Icon(Icons.contact_mail, color: Colors.grey),
                            suffixIcon: Icon(Icons.close),
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [maskFormatterCNPJ],
                          maxLength: 17,
                        ),
                        TextFormField(
                          initialValue: p.telefone,
                          onSaved: (value) => p.telefone = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Telefone",
                            hintText: "Telefone celular",
                            prefixIcon: Icon(Icons.phone, color: Colors.grey),
                            suffixIcon: Icon(Icons.close),
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
                          keyboardType: TextInputType.phone,
                          inputFormatters: [maskFormatterCelular],
                        ),
                        SizedBox(height: 10),
                        DateTimeField(
                          initialValue: p.dataRegistro,
                          format: dateFormat,
                          validator: (value) =>
                              value == null ? "campo obrigário" : null,
                          onSaved: (value) => p.dataRegistro = value,
                          decoration: InputDecoration(
                            labelText: "data registro",
                            hintText: "99-09-9999",
                            prefixIcon:
                                Icon(Icons.calendar_today, color: Colors.grey),
                            suffixIcon: Icon(Icons.close),
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
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              initialDate: currentValue ?? DateTime.now(),
                              locale: Locale('pt', 'BR'),
                              lastDate: DateTime(2030),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: p.usuario.email,
                          onSaved: (value) => p.usuario.email = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email, color: Colors.grey),
                            suffixIcon: Icon(Icons.close),
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
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: p.usuario.senha,
                          onSaved: (value) => p.usuario.senha = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Senha",
                            hintText: "Senha",
                            prefixIcon:
                                Icon(Icons.security, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.visibility, color: Colors.grey),
                              onPressed: () {
                                lojaController.visualizarSenha();
                              },
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
                          obscureText: !lojaController.senhaVisivel,
                          maxLength: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 0),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RaisedButton(
                                child: Icon(Icons.delete_forever),
                                shape: new CircleBorder(),
                                onPressed: isEnabledDelete
                                    ? () => lojaController.deleteFoto(p.foto)
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
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 300,
                                  )
                                : p.foto != null
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                          ConstantApi.urlArquivoLoja + p.foto,
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
                if (p.foto == null) {
                  openBottomSheet(context);
                } else {
                  if (p.id == null) {
                    dialogs.information(context, "prepando para o cadastro...");
                    Timer(Duration(seconds: 3), () {
                      lojaController.create(p).then((arquivo) {
                        var resultado = arquivo;
                        print("resultado : ${resultado}");
                      });
                      Navigator.of(context).pop();
                      buildPush(context);
                    });
                  } else {
                    dialogs.information(
                        context, "preparando para o alteração...");
                    Timer(Duration(seconds: 1), () {
                      lojaController.update(p.id, p);
                      Navigator.of(context).pop();
                      buildPush(context);
                    });
                  }
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
        builder: (context) => LojaPage(),
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
