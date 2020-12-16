import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/api/constants/constant_api.dart';
import 'package:nosso/src/core/controller/pedidoItem_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/pedidoitem.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/paginas/pedidoitem/pedidoitem_list.dart';
import 'package:nosso/src/paginas/pedidoitem/pedito_itens_page.dart';
import 'package:nosso/src/paginas/pedidoitem/pedito_itens_pdv.dart';
import 'package:nosso/src/util/snackbar/snackbar_global.dart';

class CaixaPageHome extends StatefulWidget {
  @override
  _CaixaPageHomeState createState() => _CaixaPageHomeState();
}

class _CaixaPageHomeState extends State<CaixaPageHome> {
  var produtoController = GetIt.I.get<ProdutoController>();
  var pedidoItemController = GetIt.I.get<PedidoItemController>();
  var focusScopeNode = FocusScopeNode();

  Produto p;
  PedidoItem pedidoItem;
  var codigoBarraController = TextEditingController();
  var quantidadeController = TextEditingController();
  var valorUnitarioController = TextEditingController();
  var valorTotalController = TextEditingController();
  var descontoController = TextEditingController();
  var valorPedidoController = TextEditingController();
  var foto;

  Controller controller;

  @override
  void initState() {
    if (p == null) {
      p = Produto();
      pedidoItem = PedidoItem();
      quantidadeController.text = 1.toString();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  showSnackbar(BuildContext context, String texto) {
    final snackbar = SnackBar(content: Text(texto));
    GlobalScaffold.instance.showSnackbar(snackbar);
  }

  buscarByCodigoDeBarra(String codigoBarra) async {
    p = await produtoController.getCodigoBarra(codigoBarra);

    if (p != null) {
      setState(() {
        pedidoItem.valorUnitario = p.estoque.valor;
        pedidoItem.quantidade = int.tryParse(quantidadeController.text);
        pedidoItem.valorTotal =
            (pedidoItem.quantidade * pedidoItem.valorUnitario);

        valorUnitarioController.text =
            pedidoItem.valorUnitario.toStringAsFixed(2);
        valorTotalController.text = pedidoItem.valorTotal.toStringAsFixed(2);

        pedidoItemController.calculateTotal();

        pedidoItemController.quantidade = pedidoItem.quantidade;

        print("Quantidade: ${pedidoItem.quantidade}");
        print("Valor unitário: ${pedidoItem.valorUnitario}");
        print("Valor total: ${pedidoItem.valorTotal}");
        print("Valor total: ${valorTotalController.text}");
        print("Descrição: ${p.descricao}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('dd-MM-yyyy HH:mm');

    return Scaffold(
      key: GlobalScaffold.instance.scaffkey,
      appBar: AppBar(
        title: Text("Caixa Home"),
      ),
      body: Observer(
        builder: (context) {
          if (pedidoItemController.dioError == null) {
            return buildForm(dateFormat, context);
          } else {
            print("Erro: ${pedidoItemController.mensagem}");
            return buildForm(dateFormat, context);
          }
        },
      ),
    );
  }

  Form buildForm(DateFormat dateFormat, BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              height: 100,
              child: Row(
                children: [
                  Container(
                    width: 300,
                    height: double.infinity,
                    color: Colors.transparent,
                    child: Center(
                      child: Text(
                        "CAIXA ABERTO",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: ListTile(
                              title: Text("Cliente"),
                              subtitle: Text("Fabio Resplandes"),
                            ),
                            height: 100,
                            width: 250,
                            color: Colors.transparent,
                          ),
                          Container(
                            child: ListTile(
                              title: Text("Vendedor"),
                              subtitle: Text("José da Costa"),
                            ),
                            height: 100,
                            width: 250,
                            color: Colors.transparent,
                          ),
                          Container(
                            child: ListTile(
                              title: Text("Horário"),
                              subtitle:
                                  Text("${dateFormat.format(DateTime.now())}"),
                            ),
                            height: 100,
                            width: 250,
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[100],
                height: 100,
                child: Row(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: double.infinity,
                      width: 700,
                      child: Column(
                        children: [
                          Container(
                            color: Colors.grey[200],
                            height: 500,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 300,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.photo, size: 100),
                                  alignment: Alignment.center,
                                ),
                                Container(
                                  width: 380,
                                  color: Colors.grey[300],
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                        initialValue: p.codigoBarra,
                                        controller: p.codigoBarra == null
                                            ? codigoBarraController
                                            : null,
                                        onSaved: (value) =>
                                            p.codigoBarra = value,
                                        onFieldSubmitted: (valor) {
                                          setState(() {
                                            codigoBarraController.text = valor;
                                            buscarByCodigoDeBarra(
                                                codigoBarraController.text);
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText:
                                              "Entre com código de barra ou clique (scanner)",
                                          hintText: "Código de barra",
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 30.0, horizontal: 10.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.purple[900]),
                                            gapPadding: 1,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        maxLength: 20,
                                      ),
                                      TextFormField(
                                        controller: quantidadeController,
                                        onSaved: (value) => p.estoque
                                            .quantidade = int.tryParse(value),
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: () =>
                                                quantidadeController.clear(),
                                            icon: Icon(Icons.clear),
                                          ),
                                          labelText:
                                              "Entre com código de barra ou clique (scanner)",
                                          hintText: "Código de barra",
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 30.0, horizontal: 10.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.purple[900]),
                                            gapPadding: 1,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        maxLength: 20,
                                      ),
                                      TextFormField(
                                        controller: valorUnitarioController,
                                        onSaved: (value) => p.estoque.valor =
                                            double.tryParse(value),
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: () =>
                                                valorUnitarioController.clear(),
                                            icon: Icon(Icons.clear),
                                          ),
                                          labelText:
                                              "Entre com código de barra ou clique (scanner)",
                                          hintText: "Código de barra",
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 30.0, horizontal: 10.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.purple[900]),
                                            gapPadding: 1,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        maxLength: 20,
                                      ),
                                      TextFormField(
                                        controller: valorTotalController,
                                        onFieldSubmitted: (valor) {
                                          setState(() {
                                            if (pedidoItemController
                                                .isExisteItem(new PedidoItem(
                                                    produto: p))) {
                                              showSnackbar(context,
                                                  "${p.nome} já existe");
                                              pedidoItemController
                                                  .calculateTotal();
                                            } else {
                                              pedidoItemController.adicionar(
                                                  new PedidoItem(produto: p));
                                              showSnackbar(context,
                                                  "${p.nome} adicionado");
                                              double total =
                                                  pedidoItemController.total;
                                              valorPedidoController.text =
                                                  total.toStringAsFixed(2);
                                              pedidoItemController
                                                  .calculateTotal();
                                              PedidoItensListPDV();
                                            }
                                          });
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: () =>
                                                valorTotalController.clear(),
                                            icon: Icon(Icons.clear),
                                          ),
                                          labelText:
                                              "Entre com código de barra ou clique (scanner)",
                                          hintText: "Código de barra",
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 30.0, horizontal: 10.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.purple[900]),
                                            gapPadding: 1,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        maxLength: 20,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(0),
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(color: Colors.blueAccent),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.green),
                                    ),
                                    child: ListTile(
                                      title: Text("descrição"),
                                      subtitle: p.nome == null
                                          ? Text(
                                              "Produto",
                                              style: TextStyle(fontSize: 40),
                                            )
                                          : Text(
                                              "${p.nome.toUpperCase()}",
                                              style: TextStyle(fontSize: 40),
                                            ),
                                    ),
                                  ),
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.green),
                                    ),
                                    child: ListTile(
                                      title: Text("descrição"),
                                      subtitle: p.nome == null
                                          ? Text(
                                              "Produto",
                                              style: TextStyle(fontSize: 40),
                                            )
                                          : Text(
                                              "${p.nome.toUpperCase()}",
                                              style: TextStyle(fontSize: 40),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.green[200],
                          border: Border.all(color: Colors.yellow),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.indigo),
                              ),
                              height: 500,
                              width: double.infinity,
                              child: PedidoItensList(),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[500],
                                  border: Border.all(color: Colors.red),
                                ),
                                height: double.infinity,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 300,
                                            color: Colors.green,
                                            child: ListTile(
                                              title: Text("Volumes"),
                                              subtitle: TextFormField(
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 25.0,
                                                          horizontal: 10.0),
                                                  filled: true,
                                                  suffixIcon: Icon(Icons.close),
                                                  labelStyle: TextStyle(
                                                      color: Colors.black),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.lime[900]),
                                                    gapPadding: 1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 100,
                                            width: 300,
                                            color: Colors.green,
                                            child: ListTile(
                                              title: Text("Valor em Vendas"),
                                              subtitle: TextFormField(
                                                controller:
                                                    valorPedidoController,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 25.0,
                                                          horizontal: 10.0),
                                                  filled: true,
                                                  suffixIcon: Icon(Icons.close),
                                                  labelStyle: TextStyle(
                                                      color: Colors.black),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.lime[900]),
                                                    gapPadding: 1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 300,
                                            color: Colors.green,
                                            child: ListTile(
                                              title: Text("Volumes"),
                                              subtitle: TextFormField(
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 25.0,
                                                          horizontal: 10.0),
                                                  filled: true,
                                                  suffixIcon: Icon(Icons.close),
                                                  labelStyle: TextStyle(
                                                      color: Colors.black),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.lime[900]),
                                                    gapPadding: 1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 100,
                                            width: 300,
                                            color: Colors.green,
                                            child: ListTile(
                                              title: Text("Valor em Vendas"),
                                              subtitle: TextFormField(
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 25.0,
                                                          horizontal: 10.0),
                                                  filled: true,
                                                  suffixIcon: Icon(Icons.close),
                                                  labelStyle: TextStyle(
                                                      color: Colors.black),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.lime[900]),
                                                    gapPadding: 1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
