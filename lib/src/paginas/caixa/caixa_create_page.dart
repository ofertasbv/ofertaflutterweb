import 'dart:async';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nosso/src/core/controller/caixa_controller.dart';
import 'package:nosso/src/core/controller/cartao_controller.dart';
import 'package:nosso/src/core/model/caixa.dart';
import 'package:nosso/src/core/model/cartao.dart';
import 'package:nosso/src/paginas/cartao/cartao_page.dart';
import 'package:nosso/src/paginas/produto/produto_search.dart';
import 'package:nosso/src/util/dialogs/dialogs.dart';
import 'package:nosso/src/util/format/uppercasetext.dart';
import 'package:nosso/src/util/validador/validador_cartao.dart';

class CaixaCreatePage extends StatefulWidget {
  Caixa caixa;

  CaixaCreatePage({Key key, this.caixa}) : super(key: key);

  @override
  _CaixaCreatePageState createState() => _CaixaCreatePageState(c: this.caixa);
}

class _CaixaCreatePageState extends State<CaixaCreatePage>
    with ValidadorCartao {
  _CaixaCreatePageState({this.c});

  var caixaController = GetIt.I.get<CaixaController>();
  var dialogs = Dialogs();

  Caixa c;
  Controller controller;

  @override
  void initState() {
    if (c == null) {
      c = Caixa();
    }
    super.initState();
  }

  @override
  didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  showToast(String cardTitle) {
    Fluttertoast.showToast(
      msg: "$cardTitle",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 10,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Caixa cadastro"),
        actions: <Widget>[
          SizedBox(width: 20),
          IconButton(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: () {
              showSearch(context: context, delegate: ProdutoSearchDelegate());
            },
          )
        ],
      ),
      body: Observer(
        builder: (context) {
          if (caixaController.dioError == null) {
            return buildListViewForm(context);
          } else {
            print("Erro: ${caixaController.mensagem}");
            showToast("${caixaController.mensagem}");
            return buildListViewForm(context);
          }
        },
      ),
    );
  }

  buildListViewForm(BuildContext context) {
    var dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    var maskFormatterNumero = new MaskTextInputFormatter(
        mask: '####-####-####-####', filter: {"#": RegExp(r'[0-9]')});
    var focus = FocusScope.of(context);

    return ListView(
      children: <Widget>[
        Container(
          color: Theme.of(context).accentColor.withOpacity(0.1),
          padding: EdgeInsets.all(0),
          child: ListTile(
            title: Text("Dados do caixa"),
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(15),
          child: Container(
            height: 200,
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor
                ],
              ),
              border: Border.all(
                color: Colors.transparent,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text("ABERTURA DE CAIXA"),
                      Icon(Icons.vpn_key_outlined),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text(
                        "${dateFormat.format(DateTime.now())}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.calculate_outlined),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text("Data Validade 12/21"),
                      Icon(Icons.calendar_today_rounded),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 0),
        Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: c.descricao,
                        onSaved: (value) => c.descricao = value,
                        validator: validateNumeroCartao,
                        decoration: InputDecoration(
                          labelText: "Descrição do caixa",
                          border: OutlineInputBorder(
                            gapPadding: 0.0,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Descrição",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                        onEditingComplete: () => focus.nextFocus(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [maskFormatterNumero],
                        maxLength: 23,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: c.referencia,
                        onSaved: (value) => c.referencia = value,
                        validator: validateNome,
                        decoration: InputDecoration(
                          labelText: "Referencia do caixa",
                          border: OutlineInputBorder(
                            gapPadding: 0.0,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Referencia do caixa",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.account_circle),
                        ),
                        onEditingComplete: () => focus.nextFocus(),
                        keyboardType: TextInputType.text,
                        inputFormatters: [UpperCaeseText()],
                        maxLength: 50,
                      ),
                      SizedBox(height: 10),
                      DateTimeField(
                        initialValue: c.dataRegistro,
                        onSaved: (value) => c.dataRegistro = value,
                        validator: validateDataValidade,
                        format: dateFormat,
                        decoration: InputDecoration(
                          labelText: "Data de registro",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                          ),
                          suffixIcon: Icon(Icons.close),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple[900]),
                            gapPadding: 1,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onEditingComplete: () => focus.nextFocus(),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            initialDate: currentValue ?? DateTime.now(),
                            locale: Locale('pt', 'BR'),
                            lastDate: DateTime(2030),
                          );
                        },
                        keyboardType: TextInputType.datetime,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(10),
          child: RaisedButton.icon(
            label: Text("Enviar formulário"),
            icon: Icon(Icons.check),
            onPressed: () {
              if (controller.validate()) {
                if (c.id == null) {
                  dialogs.information(context, "prepando para o cadastro...");
                  Timer(Duration(seconds: 3), () {
                    caixaController.create(c).then((value) {
                      print("resultado : ${value}");
                    });
                    Navigator.of(context).pop();
                    buildPush(context);
                  });
                } else {
                  dialogs.information(
                      context, "preparando para o alteração...");
                  Timer(Duration(seconds: 3), () {
                    caixaController.update(c.id, c);
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

  buildPush(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartaoPage(),
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