import 'dart:async';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/core/controller/loja_controller.dart';
import 'package:nosso/src/core/controller/pedidoItem_controller.dart';
import 'package:nosso/src/core/controller/pedido_controller.dart';
import 'package:nosso/src/core/controller/usuario_controller.dart';
import 'package:nosso/src/core/model/cliente.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/core/model/pedido.dart';
import 'package:nosso/src/core/model/pedidoitem.dart';
import 'package:nosso/src/core/model/usuario.dart';
import 'package:nosso/src/paginas/pedidoitem/pedito_itens_page.dart';
import 'package:nosso/src/paginas/permissao/permissao_page.dart';
import 'package:nosso/src/util/dialogs/dialogs.dart';
import 'package:nosso/src/util/steps/step_menu_etapa.dart';
import 'package:nosso/src/util/validador/validador_pedido.dart';

class PedidoCreatePage extends StatefulWidget {
  Pedido pedido;

  PedidoCreatePage({Key key, this.pedido}) : super(key: key);

  @override
  _PedidoCreatePageState createState() =>
      _PedidoCreatePageState(p: this.pedido);
}

class _PedidoCreatePageState extends State<PedidoCreatePage>
    with ValidadorPedido {
  _PedidoCreatePageState({this.p});

  var pedidoController = GetIt.I.get<PedidoController>();
  var pedidoItemController = GetIt.I.get<PedidoItemController>();
  var usuarioController = GetIt.I.get<UsuarioController>();
  var lojaController = GetIt.I.get<LojaController>();

  Dialogs dialogs = Dialogs();

  Pedido p;
  Usuario cliente;
  Usuario loja;
  Loja l;
  Cliente c;
  String statusPedido;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  var nomeCotroller = TextEditingController();
  var valorInicialCotroller = TextEditingController();
  var descontoCotroller = TextEditingController();
  var valorFreteCotroller = TextEditingController();
  var valorTotalCotroller = TextEditingController();

  @override
  void initState() {
    if (p == null) {
      p = Pedido();
      cliente = Usuario();
      loja = Usuario();
      l = Loja();
      c = Cliente();
    }
    super.initState();
  }

  Controller controller;

  @override
  void didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  buscarClienteByEmail(String email) async {
    cliente = await usuarioController.getEmail(email);
    return cliente;
  }

  buscarLojaByEmail(String email) async {
    loja = await usuarioController.getEmail(email);
    return loja;
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
    var focus = FocusScope.of(context);
    var dateFormat = DateFormat('dd/MM/yyyy');
    var formatter = NumberFormat("00.00");
    var formata = new NumberFormat("#,##0.00", "pt_BR");

    return ListView(
      children: <Widget>[
        Container(
          color: Colors.grey[200],
          child: ExpansionTile(
            leading: Icon(
              Icons.shopping_basket_outlined,
              color: Colors.blue,
            ),
            title: Text(
              "Meus itens",
              style: TextStyle(
                color: Colors.blue,
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
        StepMenuEtapa(
          colorPedido: Colors.grey,
          colorPagamento: Colors.orangeAccent,
          colorConfirmacao: Colors.orangeAccent,
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
                        initialValue: p.descricao,
                        onSaved: (value) => p.descricao = value,
                        validator: validateDescricao,
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
                        onEditingComplete: () => focus.nextFocus(),
                        keyboardType: TextInputType.text,
                        maxLength: 200,
                        maxLines: null,
                        //initialValue: c.nome,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: valorInicialCotroller,
                        onSaved: (value) {
                          p.valorInicial = double.tryParse(value);
                        },
                        validator: validateDesconto,
                        decoration: InputDecoration(
                          labelText: "Valor inicial",
                          hintText: "Valor inicial",
                          prefixIcon: Icon(
                            Icons.monetization_on_outlined,
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => valorInicialCotroller.clear(),
                            icon: Icon(Icons.clear),
                          ),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo[900]),
                            gapPadding: 1,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onEditingComplete: () => focus.nextFocus(),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        maxLength: 6,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: valorFreteCotroller,
                        onSaved: (value) {
                          p.valorFrete = double.tryParse(value);
                        },
                        validator: validateValorFrete,
                        decoration: InputDecoration(
                          labelText: "Valor de entrega",
                          hintText: "Valor de entrega",
                          prefixIcon: Icon(
                            Icons.monetization_on_outlined,
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => valorFreteCotroller.clear(),
                            icon: Icon(Icons.clear),
                          ),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo[900]),
                            gapPadding: 1,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onEditingComplete: () => focus.nextFocus(),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        maxLength: 6,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: descontoCotroller,
                        onSaved: (value) {
                          p.valorDesconto = double.tryParse(value);
                        },
                        validator: validateDesconto,
                        onChanged: (percentual) {
                          setState(() {
                            double valor = (double.tryParse(
                                    valorInicialCotroller.text) -
                                ((double.tryParse(valorInicialCotroller.text) *
                                        double.tryParse(
                                            descontoCotroller.text)) /
                                    100) +
                                double.tryParse(valorFreteCotroller.text));
                            valorTotalCotroller.text = valor.toStringAsFixed(2);
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Percentual de desconto",
                          hintText: "Percentual de desconto",
                          prefixIcon: Icon(
                            Icons.monetization_on_outlined,
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => descontoCotroller.clear(),
                            icon: Icon(Icons.clear),
                          ),
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
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        maxLength: 10,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: valorTotalCotroller,
                        onSaved: (value) {
                          p.valorTotal = double.tryParse(value);
                        },
                        validator: validateValorTotal,
                        decoration: InputDecoration(
                          labelText: "Valor Total",
                          hintText: "Valor total",
                          prefixIcon: Icon(
                            Icons.monetization_on_outlined,
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => valorTotalCotroller.clear(),
                            icon: Icon(Icons.clear),
                          ),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo[900]),
                            gapPadding: 1,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onEditingComplete: () => focus.nextFocus(),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        maxLength: 6,
                      ),
                      SizedBox(height: 10),
                      DateTimeField(
                        initialValue: p.dataRegistro,
                        format: dateFormat,
                        validator: validateDateEntrega,
                        onSaved: (value) => p.dataRegistro = value,
                        decoration: InputDecoration(
                          labelText: "data de resgistro",
                          hintText: "99-09-9999",
                          prefixIcon: Icon(Icons.calendar_today),
                          suffixIcon: Icon(Icons.close),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo[900]),
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
                        maxLength: 10,
                      ),
                      SizedBox(height: 10),
                      DateTimeField(
                        initialValue: p.dataHoraEntrega,
                        format: dateFormat,
                        validator: validateDateHoraEntrega,
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
                            borderSide: BorderSide(color: Colors.indigo[900]),
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
                        maxLength: 10,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Container(
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
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: Text("CRIADO"),
                              value: "CRIADO",
                              groupValue: statusPedido,
                              secondary: const Icon(Icons.shop_outlined),
                              onChanged: (String valor) {
                                setState(() {
                                  statusPedido = valor;
                                  print("STATUS: " + statusPedido);
                                });
                              },
                            ),
                            RadioListTile(
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: Text("CANCELADO"),
                              value: "CANCELADO",
                              groupValue: statusPedido,
                              secondary:
                                  const Icon(Icons.delete_outline_outlined),
                              onChanged: (String valor) {
                                setState(() {
                                  statusPedido = valor;
                                  print("STATUS: " + statusPedido);
                                });
                              },
                            ),
                            RadioListTile(
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: Text("ENTREGUE"),
                              value: "ENTREGUE",
                              groupValue: statusPedido,
                              secondary: const Icon(Icons.delivery_dining),
                              onChanged: (String valor) {
                                setState(() {
                                  statusPedido = valor;
                                  print("STATUS: " + statusPedido);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 0),
        Container(
          padding: EdgeInsets.all(15),
          child: RaisedButton.icon(
            label: Text("Enviar formulário"),
            icon: Icon(Icons.check),
            onPressed: () {
              if (controller.validate()) {
                if (p.id == null) {
                  dialogs.information(context, "prepando para o cadastro...");
                  Timer(Duration(seconds: 3), () {
                    buscarClienteByEmail("projetogdados@gmail.com");
                    buscarLojaByEmail("lojadauris@gmail.com");

                    p.valorTotal = (pedidoItemController.total -
                        ((pedidoItemController.total * p.valorDesconto) / 100) +
                        p.valorFrete);

                    print("Cliente: ${c.nome}");
                    // print("Loja: ${loja.email}");

                    print("Descrição: ${p.descricao}");
                    print("Desconto: ${p.valorDesconto}");
                    print("Frete: ${p.valorFrete}");
                    print("Valor total: ${p.valorTotal}");

                    print("Pagamento: ${p.formaPagamento}");
                    print("Status: ${p.statusPedido}");

                    print("Data de regsitro: ${p.dataRegistro}");
                    print("Data e hora da entrega: ${p.dataHoraEntrega}");

                    for (PedidoItem item in pedidoItemController.itens) {
                      print("Produto: ${item.produto.nome}");
                    }

                    pedidoController.create(p).then((value) {
                      print("resultado : ${value}");
                    });
                    Navigator.of(context).pop();
                    buildPush(context);
                  });
                } else {
                  dialogs.information(
                      context, "preparando para o alteração...");
                  Timer(Duration(seconds: 3), () {
                    p.valorTotal = (pedidoItemController.total -
                        ((pedidoItemController.total * p.valorDesconto) / 100) +
                        p.valorFrete);

                    print("Descrição: ${p.descricao}");
                    print("Desconto: ${p.valorDesconto}");
                    print("Frete: ${p.valorFrete}");
                    print("Valor total: ${p.valorTotal}");

                    print("Pagamento: ${p.formaPagamento}");
                    print("Status: ${p.statusPedido}");

                    print("Data de resgistro: ${p.dataRegistro}");
                    print("Data e hora da entrega: ${p.dataHoraEntrega}");

                    // pedidoController.update(p.id, p);
                    // Navigator.of(context).pop();
                    // buildPush(context);
                  });
                }
              }
            },
          ),
        ),
        SizedBox(height: 20),
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
