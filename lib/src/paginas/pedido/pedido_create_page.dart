import 'dart:async';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/core/controller/pedidoItem_controller.dart';
import 'package:nosso/src/core/controller/pedido_controller.dart';
import 'package:nosso/src/core/model/pedido.dart';
import 'package:nosso/src/paginas/pedidoitem/pedito_itens_page.dart';
import 'package:nosso/src/paginas/permissao/permissao_page.dart';
import 'package:nosso/src/util/dialogs/dialogs.dart';

class PedidoCreatePage extends StatefulWidget {
  Pedido pedido;

  PedidoCreatePage({Key key, this.pedido}) : super(key: key);

  @override
  _PedidoCreatePageState createState() =>
      _PedidoCreatePageState(p: this.pedido);
}

class _PedidoCreatePageState extends State<PedidoCreatePage> {
  _PedidoCreatePageState({this.p});

  var pedidoController = GetIt.I.get<PedidoController>();
  var pedidoItemController = GetIt.I.get<PedidoItemController>();

  Dialogs dialogs = Dialogs();

  Pedido p;
  String formaPagamento;
  String statusPedido;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  var controllerNome = TextEditingController();

  @override
  void initState() {
    if (p == null) {
      p = Pedido();
    }
    super.initState();
  }

  Controller controller;

  @override
  void didChangeDependencies() {
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
        title: Text("Pedido cadastros"),
      ),
      body: Observer(
        builder: (context) {
          if (pedidoController.dioError == null) {
            return buildListViewForm(context);
          } else {
            print("Erro: ${pedidoController.mensagem}");
            showToast("${pedidoController.mensagem}");
            return buildListViewForm(context);
          }
        },
      ),
    );
  }

  buildListViewForm(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    NumberFormat formatter = NumberFormat("00.00");
    NumberFormat formata = new NumberFormat("#,##0.00", "pt_BR");

    return ListView(
      children: <Widget>[
        Container(
          color: Colors.grey[200],
          child: ExpansionTile(
            leading: Icon(
              Icons.shopping_basket_outlined,
              color: Colors.purple[800],
            ),
            title: Text(
              "Meus itens",
              style: TextStyle(
                color: Colors.purple[800],
              ),
            ),
            children: [
              Container(
                height: 400,
                child: PedidoItensList(),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
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
                          initialValue: p.descricao,
                          onSaved: (value) => p.descricao = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Descrição",
                            hintText: "Descrição",
                            prefixIcon: Icon(Icons.edit, color: Colors.grey),
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
                          maxLines: 1,
                          //initialValue: c.nome,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onSaved: (value) {
                            p.valorDesconto = double.tryParse(value);
                          },
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Desconto",
                            hintText: "Desconto",
                            prefixIcon: Icon(
                              Icons.monetization_on_outlined,
                              color: Colors.grey,
                            ),
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
                          maxLength: 6,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onSaved: (value) {
                            p.valorFrete = double.tryParse(value);
                          },
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Frete",
                            hintText: "frete",
                            prefixIcon: Icon(
                              Icons.monetization_on_outlined,
                              color: Colors.grey,
                            ),
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
                          maxLength: 6,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onSaved: (value) {
                            p.valorTotal = double.tryParse(value);
                          },
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Valor Total",
                            hintText: "Valor total",
                            prefixIcon: Icon(
                              Icons.monetization_on_outlined,
                              color: Colors.grey,
                            ),
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
                          maxLength: 6,
                        ),
                        SizedBox(height: 10),
                        DateTimeField(
                          initialValue: p.dataEntrega,
                          format: dateFormat,
                          validator: (value) =>
                              value == null ? "campo obrigário" : null,
                          onSaved: (value) => p.dataEntrega = value,
                          decoration: InputDecoration(
                            labelText: "data da entrega",
                            hintText: "99-09-9999",
                            prefixIcon: Icon(Icons.calendar_today),
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
                        SizedBox(height: 20),
                        DateTimeField(
                          initialValue: p.dataHoraEntrega,
                          format: dateFormat,
                          validator: (value) =>
                              value == null ? "campo obrigário" : null,
                          onSaved: (value) => p.dataHoraEntrega = value,
                          decoration: InputDecoration(
                            labelText: "data e hora da entrega",
                            hintText: "99-09-9999",
                            prefixIcon: Icon(Icons.calendar_today),
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
                        SizedBox(height: 20),
                        DateTimeField(
                          initialValue: p.horarioEntrega,
                          format: dateFormat,
                          validator: (value) =>
                              value == null ? "campo obrigário" : null,
                          onSaved: (value) => p.horarioEntrega = value,
                          decoration: InputDecoration(
                            labelText: "hora da entrega",
                            hintText: "99-09-9999",
                            prefixIcon: Icon(Icons.calendar_today),
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
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Forma de pagamento"),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("BOLETO BANCARIO"),
                                value: "BOLETO_BANCARIO",
                                groupValue: p.formaPagamento == null
                                    ? p.formaPagamento = formaPagamento
                                    : p.formaPagamento,
                                secondary:
                                    const Icon(Icons.picture_as_pdf_outlined),
                                onChanged: (String valor) {
                                  setState(() {
                                    p.formaPagamento = valor;
                                    print("Pagamento: " + p.formaPagamento);
                                  });
                                },
                              ),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("TRANSFERENCIA BANCARIA"),
                                value: "TRANSFERENCIA_BANCARIA",
                                groupValue: p.formaPagamento == null
                                    ? p.formaPagamento = formaPagamento
                                    : p.formaPagamento,
                                secondary: const Icon(Icons.local_atm),
                                onChanged: (String valor) {
                                  setState(() {
                                    p.formaPagamento = valor;
                                    print("Pagamento: " + p.formaPagamento);
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
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Status do pedido"),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("EMITIDA"),
                                value: "EMITIDA",
                                groupValue: p.statusPedido == null
                                    ? p.statusPedido = statusPedido
                                    : p.statusPedido,
                                secondary: const Icon(Icons.check_outlined),
                                onChanged: (String valor) {
                                  setState(() {
                                    p.statusPedido = valor;
                                    print("STATUS: " + p.statusPedido);
                                  });
                                },
                              ),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("ORCAMENTO"),
                                value: "ORCAMENTO",
                                groupValue: p.statusPedido == null
                                    ? p.statusPedido = statusPedido
                                    : p.statusPedido,
                                secondary: const Icon(Icons.local_atm),
                                onChanged: (String valor) {
                                  setState(() {
                                    p.statusPedido = valor;
                                    print("STATUS: " + p.statusPedido);
                                  });
                                },
                              ),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("CANCELADA"),
                                value: "CANCELADA",
                                groupValue: p.statusPedido == null
                                    ? p.statusPedido = statusPedido
                                    : p.statusPedido,
                                secondary:
                                    const Icon(Icons.delete_forever_sharp),
                                onChanged: (String valor) {
                                  setState(() {
                                    p.statusPedido = valor;
                                    print("STATUS: " + p.statusPedido);
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
              ],
            ),
          ),
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
              if (p.id == null) {
                dialogs.information(context, "prepando para o cadastro...");
                Timer(Duration(seconds: 3), () {
                  print("Descrição: ${p.descricao}");
                  print("Desconto: ${p.valorDesconto}");
                  print("Frete: ${p.valorFrete}");

                  print("Pagamento: ${p.formaPagamento}");
                  print("Status: ${p.statusPedido}");

                  print("Data da entrega: ${p.dataEntrega}");
                  print("Data e hora da entrega: ${p.dataHoraEntrega}");
                  print("Hora entrega: ${p.horarioEntrega}");

                  // pedidoController.create(p);
                  // Navigator.of(context).pop();
                  // buildPush(context);
                });
              } else {
                dialogs.information(context, "preparando para o alteração...");
                Timer(Duration(seconds: 3), () {
                  print("Descrição: ${p.descricao}");
                  print("Desconto: ${p.valorDesconto}");
                  print("Frete: ${p.valorFrete}");

                  print("Pagamento: ${p.formaPagamento}");
                  print("Status: ${p.statusPedido}");

                  print("Data da entrega: ${p.dataEntrega}");
                  print("Data e hora da entrega: ${p.dataHoraEntrega}");
                  print("Hora entrega: ${p.horarioEntrega}");

                  // pedidoController.update(p.id, p);
                  // Navigator.of(context).pop();
                  // buildPush(context);
                });
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
        builder: (context) => PermissaoPage(),
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
