import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/loja_controller.dart';
import 'package:nosso/src/core/controller/promocao_controller.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/core/model/promocao.dart';
import 'package:nosso/src/core/repository/promocao_repository.dart';
import 'package:nosso/src/paginas/promocao/promocao_page.dart';
import 'package:nosso/src/util/converter/thousandsFormatter.dart';

class PromocaoCreatePage extends StatefulWidget {
  Promocao promocao;

  PromocaoCreatePage({Key key, this.promocao}) : super(key: key);

  @override
  _PromocaoCreatePageState createState() =>
      _PromocaoCreatePageState(p: promocao);
}

class _PromocaoCreatePageState extends State<PromocaoCreatePage> {
  PromoCaoController promocaoController = GetIt.I.get<PromoCaoController>();
  LojaController lojaController = GetIt.I.get<LojaController>();

  Future<List<Loja>> lojas;

  Promocao p;
  Loja lojaSelecionada;

  _PromocaoCreatePageState({this.p});

  DateTime dataAtual = DateTime.now();
  String valor;
  String valorSlecionado;
  File file;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController descontoController = TextEditingController();

  @override
  void initState() {
    promocaoController.getAll();
    lojas = lojaController.getAll();
    if (p == null) {
      p = Promocao();
    }
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
      p.foto = filePath;
    });
  }

  onClickUpload() async {
    if (file != null) {
      var url = await PromocaoRepository.upload(file, p.foto);
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

  void showToast(String cardTitle) {
    Fluttertoast.showToast(
      msg: "$cardTitle",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    NumberFormat numberFormat = NumberFormat("00.00");

    // p.desconto = double.tryParse(descontoController.text);

    p.loja = lojaSelecionada;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Promoção cadastro"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: onClickFoto,
          )
        ],
      ),
      body: Observer(
        builder: (context) {
          if (promocaoController.error != null) {
            print("erro1: ${promocaoController.error}");
            return Text("Não foi possível cadastrar promoção");
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
                                  autofocus: true,
                                  initialValue: p.nome,
                                  onSaved: (value) => p.nome = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Título",
                                    hintText: "título promoção",
                                    prefixIcon: Icon(Icons.edit),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 100,
                                  maxLines: 2,
                                ),
                                TextFormField(
                                  autofocus: true,
                                  initialValue: p.descricao,
                                  onSaved: (value) => p.descricao = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Descrição",
                                    hintText: "descrição promoção",
                                    prefixIcon: Icon(Icons.description),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  maxLength: 100,
                                  maxLines: 2,
                                  keyboardType: TextInputType.text,
                                ),
                                TextFormField(
                                  showCursor: true,
                                  autofocus: true,
                                  onSaved: (value) =>
                                      p.desconto = double.tryParse(value),
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Desconto",
                                    hintText: "desconto promoção",
                                    prefixIcon: Icon(Icons.monetization_on),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  maxLength: 4,
                                ),
                                SizedBox(height: 15),
                                DateTimeField(
                                  initialValue: p.dataRegistro,
                                  format: dateFormat,
                                  validator: (value) =>
                                      value == null ? "campo obrigário" : null,
                                  onSaved: (value) => p.dataRegistro = value,
                                  decoration: InputDecoration(
                                    labelText: "data registro",
                                    hintText: "99-09-9999",
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      size: 24,
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  onShowPicker: (context, currentValue) {
                                    return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      locale: Locale('pt', 'BR'),
                                      lastDate: DateTime(2030),
                                    );
                                  },
                                ),
                                SizedBox(height: 15),
                                DateTimeField(
                                  initialValue: p.dataInicio,
                                  format: dateFormat,
                                  validator: (value) =>
                                      value == null ? "campo obrigário" : null,
                                  onSaved: (value) => p.dataInicio = value,
                                  decoration: InputDecoration(
                                    labelText: "data inicio",
                                    hintText: "99-09-9999",
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      size: 24,
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  onShowPicker: (context, currentValue) {
                                    return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      locale: Locale('pt', 'BR'),
                                      lastDate: DateTime(2030),
                                    );
                                  },
                                ),
                                SizedBox(height: 15),
                                DateTimeField(
                                  initialValue: p.dataFinal,
                                  format: dateFormat,
                                  validator: (value) =>
                                      value == null ? "campo obrigário" : null,
                                  onSaved: (value) => p.dataFinal = value,
                                  decoration: InputDecoration(
                                    labelText: "data encerramento",
                                    hintText: "99-09-9999",
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      size: 24,
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  onShowPicker: (context, currentValue) {
                                    return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
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
                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: <Widget>[
                                FutureBuilder<List<Loja>>(
                                  future: lojas,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return DropdownButtonFormField<Loja>(
                                        validator: (value) => value == null
                                            ? 'selecione uma loja'
                                            : null,
                                        value: lojaSelecionada,
                                        items: snapshot.data.map((loja) {
                                          return DropdownMenuItem<Loja>(
                                            value: loja,
                                            child: Text(loja.nome),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          labelText: "Loja",
                                          filled: true,
                                          fillColor: Colors.white,
                                          prefixIcon:
                                              Icon(Icons.local_convenience_store_outlined),
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
                                        onChanged: (Loja c) {
                                          setState(() {
                                            lojaSelecionada = c;
                                            print(lojaSelecionada.nome);
                                          });
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("${snapshot.error}");
                                    }

                                    return Text(
                                        "não foi peossível carregar lojas");
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
                                          ? () => promocaoController
                                              .deleteFoto(p.foto)
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
                                        : p.foto != null
                                            ? Image.network(
                                                ConstantApi.urlArquivoPromocao +
                                                    p.foto,
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
                              openAlertBox(context, p);
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
        builder: (context) => PromocaoPage(),
      ),
    );
  }

  openAlertBox(BuildContext context, Promocao p) {
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
                    subtitle: Text("${p.nome}"),
                  ),
                ),
                Container(
                  child: ListTile(
                    title: Text("Foto"),
                    subtitle: Text("${p.foto}"),
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
                            if (p.id == null) {
                              Timer(Duration(seconds: 3), () {
                                promocaoController.create(p);
                                showToast("Cadastro  realizado com sucesso");
                                Navigator.of(context).pop();
                                buildPush(context);
                              });
                            } else {
                              Timer(Duration(seconds: 3), () {
                                promocaoController.update(p.id, p);
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
