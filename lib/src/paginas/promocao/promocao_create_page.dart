import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:brasil_fields/formatter/real_input_formatter.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      p.desconto = 0.0;
    }
    lojaSelecionada = p.loja;
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
      var atual = DateTime.now();
      setState(() {
        this.file = f;
        String arquivo = file.path.split('/').last;
        String filePath = arquivo.replaceAll(
            "$arquivo", "promocao-" + atual.toString() + ".png");
        print("arquivo: $arquivo");
        print("filePath: $filePath");
        p.foto = filePath;
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
        p.foto = filePath;
      });
    }
  }

  onClickUpload() async {
    if (file != null) {
      var url = await PromocaoRepository.upload(file, p.foto);
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

    String desconto = descontoController.text;
    p.desconto = double.tryParse(desconto);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Promoção cadastro"),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
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
                                    labelText: "Título",
                                    hintText: "título promoção",
                                    prefixIcon: Icon(Icons.edit),
                                    suffixIcon: Icon(Icons.close),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 100,
                                  maxLines: null,
                                ),
                                TextFormField(
                                  initialValue: p.descricao,
                                  onSaved: (value) => p.descricao = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Descrição",
                                    hintText: "descrição promoção",
                                    prefixIcon: Icon(Icons.description),
                                    suffixIcon: Icon(Icons.close),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  maxLength: 100,
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                ),
                                TextFormField(
                                  // controller: descontoController,
                                  onSaved: (value) =>
                                      p.desconto = double.tryParse(value),
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Desconto",
                                    hintText: "R\$ ",
                                    prefixIcon: Icon(Icons.monetization_on),
                                    suffixIcon: Icon(Icons.close),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    RealInputFormatter(centavos: true)
                                  ],
                                  maxLength: 5,
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
                                    prefixIcon: Icon(Icons.calendar_today),
                                    suffixIcon: Icon(Icons.close),
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
                                SizedBox(height: 10),
                                DateTimeField(
                                  initialValue: p.dataInicio,
                                  format: dateFormat,
                                  validator: (value) =>
                                      value == null ? "campo obrigário" : null,
                                  onSaved: (value) => p.dataInicio = value,
                                  decoration: InputDecoration(
                                    labelText: "data inicio",
                                    hintText: "99-09-9999",
                                    prefixIcon: Icon(Icons.calendar_today),
                                    suffixIcon: Icon(Icons.close),
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
                                SizedBox(height: 10),
                                DateTimeField(
                                  initialValue: p.dataFinal,
                                  format: dateFormat,
                                  validator: (value) =>
                                      value == null ? "campo obrigário" : null,
                                  onSaved: (value) => p.dataFinal = value,
                                  decoration: InputDecoration(
                                    labelText: "data encerramento",
                                    hintText: "99-09-9999",
                                    prefixIcon: Icon(Icons.calendar_today),
                                    suffixIcon: Icon(Icons.close),
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
                            padding: EdgeInsets.all(5),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListTile(
                                title: Text("Loja *"),
                                subtitle: lojaSelecionada == null
                                    ? Text("Selecione uma loja")
                                    : Text(lojaSelecionada.nome),
                                leading: Icon(Icons.list_alt_outlined),
                                trailing: Icon(Icons.arrow_drop_down_sharp),
                                onTap: () {
                                  alertSelectLojas(context, lojaSelecionada);
                                },
                              ),
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
                                borderRadius: BorderRadius.circular(5),
                              ),
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
                                        : p.foto != null
                                            ? CircleAvatar(
                                                radius: 50,
                                                backgroundImage: NetworkImage(
                                                  ConstantApi
                                                          .urlArquivoPromocao +
                                                      p.foto,
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
                        openAlertBox(context, p);
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
                    Text("Informação"),
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
                    title: Text("Deseja realizar essa operação? "),
                  ),
                ),
                SizedBox(height: 5),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32.0),
                        bottomRight: Radius.circular(32.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          color: Colors.red,
                          child: const Text('CANCELAR'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          color: Colors.green,
                          child: const Text('CONFIRMAR'),
                          onPressed: () {
                            if (p.id == null) {
                              Timer(Duration(seconds: 3), () {
                                onClickUpload();
                                p.loja = lojaSelecionada;
                                promocaoController.create(p);

                                showToast("Cadastro  realizado com sucesso");
                                Navigator.of(context).pop();
                                buildPush(context);
                              });
                            } else {
                              Timer(Duration(seconds: 3), () {
                                onClickUpload();
                                p.loja = lojaSelecionada;
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

  alertSelectLojas(BuildContext context, Loja c) {
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
          List<Loja> categorias = lojaController.lojas;
          if (lojaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (categorias == null) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          }

          return builderListCategorias(categorias);
        },
      ),
    );
  }

  builderListCategorias(List<Loja> lojas) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.separated(
      itemCount: lojas.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        Loja c = lojas[index];

        return GestureDetector(
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                "${ConstantApi.urlArquivoLoja + c.foto}",
              ),
            ),
            title: Text(c.nome),
          ),
          onTap: () {
            setState(() {
              lojaSelecionada = c;
              print("${lojaSelecionada.nome}");
            });
            Navigator.of(context).pop();
          },
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
