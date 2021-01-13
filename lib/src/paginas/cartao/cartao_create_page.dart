import 'dart:async';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/cartao_controller.dart';
import 'package:nosso/src/core/model/cartao.dart';
import 'package:nosso/src/paginas/cartao/cartao_page.dart';
import 'package:nosso/src/paginas/produto/produto_search.dart';
import 'package:nosso/src/util/dialogs/dialogs.dart';
import 'package:nosso/src/util/validador/validador_cartao.dart';

class CartaoCreatePage extends StatefulWidget {
  Cartao cartao;
  CartaoCreatePage({Key key, this.cartao}) : super(key: key);

  @override
  _CartaoCreatePageState createState() =>
      _CartaoCreatePageState(c: this.cartao);
}

class _CartaoCreatePageState extends State<CartaoCreatePage>
    with ValidadorCartao {
  _CartaoCreatePageState({this.c});

  var cartaoController = GetIt.I.get<CartaoController>();
  var dialogs = Dialogs();

  Cartao c;
  Controller controller;

  @override
  void initState() {
    if (c == null) {
      c = Cartao();
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
        title: Text("Cartão cadastro"),
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
          if (cartaoController.dioError == null) {
            return buildListViewForm(context);
          } else {
            print("Erro: ${cartaoController.mensagem}");
            showToast("${cartaoController.mensagem}");
            return buildListViewForm(context);
          }
        },
      ),
    );
  }

  buildListViewForm(BuildContext context) {
    var focus = FocusScope.of(context);

    return ListView(
      children: <Widget>[
        Container(
          color: Theme.of(context).accentColor.withOpacity(0.1),
          padding: EdgeInsets.all(0),
          child: ListTile(
            title: Text("Dados ddo cartão de crédito"),
          ),
        ),
        SizedBox(height: 20),
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
                        initialValue: c.numeroCartao,
                        onSaved: (value) => c.numeroCartao = value,
                        validator: validateNumeroCartao,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            gapPadding: 0.0,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Nº do cartão",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: c.nome,
                        onSaved: (value) => c.nome = value,
                        validator: validateNome,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            gapPadding: 0.0,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Nome do cartão",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.account_circle),
                        ),
                      ),
                      SizedBox(height: 10),
                      DateTimeField(
                        initialValue: c.dataValidade,
                        onSaved: (value) => c.dataValidade = value,
                        validator: validateDataValidade,
                        decoration: InputDecoration(
                          labelText: "data validade",
                          hintText: "99-99",
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
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: c.numeroSeguranca,
                        onSaved: (value) => c.numeroSeguranca = value,
                        validator: validateNumeroSeguranca,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            gapPadding: 0.0,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Código de segurança",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.enhanced_encryption),
                        ),
                        onEditingComplete: () => focus.nextFocus(),
                        keyboardType: TextInputType.text,
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
                    cartaoController.create(c).then((value) {
                      print("resultado : ${value}");
                    });
                    Navigator.of(context).pop();
                    buildPush(context);
                  });
                } else {
                  dialogs.information(
                      context, "preparando para o alteração...");
                  Timer(Duration(seconds: 3), () {
                    cartaoController.update(c.id, c);
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
