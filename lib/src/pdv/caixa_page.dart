import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/api/constants/constant_api.dart';
import 'package:nosso/src/core/controller/pedidoItem_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/produto.dart';

class CaixaPageHome extends StatefulWidget {
  @override
  _CaixaPageHomeState createState() => _CaixaPageHomeState();
}

class _CaixaPageHomeState extends State<CaixaPageHome> {
  var produtoController = GetIt.I.get<ProdutoController>();
  var pedidoItemController = GetIt.I.get<PedidoItemController>();
  var focusScopeNode = FocusScopeNode();

  Produto p;
  var codigoBarraController = TextEditingController();
  var quantidadeController = TextEditingController();
  var valorUnitarioController = TextEditingController();
  var valorTotalController = TextEditingController();
  var descontoController = TextEditingController();
  var foto;

  Controller controller;

  buscarByCodigoDeBarra(String codigoBarra) async {
    p = await produtoController.getCodigoBarra(codigoBarra);
    valorUnitarioController.text = p.estoque.valor.toStringAsFixed(2);
    foto = ConstantApi.urlArquivoProduto + p.foto;
    print(p.descricao);
  }

  @override
  void initState() {
    if (p == null) {
      p = Produto();
      quantidadeController.text = 1.toString();
    } else {
      valorUnitarioController.text = p.estoque.valor.toStringAsFixed(2);
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

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('dd-MM-yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text("Caixa Home"),
      ),
      body: Form(
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
                                subtitle: Text(
                                    "${dateFormat.format(DateTime.now())}"),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 300,
                                    color: Colors.grey[300],
                                    child: p.foto == null
                                        ? Image.asset(
                                            ConstantApi.urlLogo,
                                            width: 200,
                                            height: 200,
                                          )
                                        : Image.network(
                                            foto,
                                            width: 200,
                                            height: 200,
                                          ),
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
                                        Container(
                                          child: ListTile(
                                            title: Text("Código de Barra"),
                                            subtitle: TextFormField(
                                              controller: codigoBarraController,
                                              decoration: InputDecoration(
                                                filled: true,
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                      Icons.search_outlined,
                                                      color: Colors.grey),
                                                  onPressed: () {
                                                    setState(() {
                                                      buscarByCodigoDeBarra(
                                                        codigoBarraController
                                                            .text,
                                                      );

                                                      double quantidade =
                                                          double.tryParse(
                                                              quantidadeController
                                                                  .text);
                                                      double valorUnitario =
                                                          double.tryParse(
                                                              valorUnitarioController
                                                                  .text);
                                                      double valorTotal =
                                                          quantidade *
                                                              valorUnitario;
                                                      valorTotalController
                                                              .text =
                                                          valorTotal
                                                              .toStringAsFixed(
                                                                  2);
                                                    });
                                                  },
                                                ),
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
                                                      color: Colors.lime[900]),
                                                  gapPadding: 1,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              keyboardType: TextInputType.text,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: ListTile(
                                            title: Text("Quantidade"),
                                            subtitle: TextFormField(
                                              controller: quantidadeController,
                                              decoration: InputDecoration(
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
                                                      color: Colors.lime[900]),
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
                                          child: ListTile(
                                            title: Text("Valor Unitário"),
                                            subtitle: TextFormField(
                                              controller:
                                                  valorUnitarioController,
                                              decoration: InputDecoration(
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
                                                      color: Colors.lime[900]),
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
                                          child: ListTile(
                                            title: Text("Valor Total"),
                                            subtitle: TextFormField(
                                              controller: valorTotalController,
                                              decoration: InputDecoration(
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
                                                      color: Colors.lime[900]),
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
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(30),
                                color: Colors.grey[300],
                                height: double.infinity,
                                width: double.infinity,
                                child: Container(
                                  child: ListTile(
                                    title: Text("descrição"),
                                    subtitle: p.nome == null
                                        ? Text(
                                            "Produto",
                                            style: TextStyle(fontSize: 40),
                                          )
                                        : Text(
                                            "${p.nome}",
                                            style: TextStyle(fontSize: 40),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.pink,
                          height: double.infinity,
                          width: 300,
                          child: Column(
                            children: [
                              Container(
                                color: Colors.grey[100],
                                height: 500,
                                width: double.infinity,
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.grey[300],
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        child: ListTile(
                                          title: Text("Volumes"),
                                          subtitle: TextFormField(
                                            decoration: InputDecoration(
                                              filled: true,
                                              suffixIcon: Icon(Icons.close),
                                              labelStyle: TextStyle(
                                                  color: Colors.black),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.lime[900]),
                                                gapPadding: 1,
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        height: 100,
                                        width: 230,
                                      ),
                                      Container(
                                        child: ListTile(
                                          title: Text("Valor em Vendas"),
                                          subtitle: TextFormField(
                                            decoration: InputDecoration(
                                              filled: true,
                                              suffixIcon: Icon(Icons.close),
                                              labelStyle: TextStyle(
                                                  color: Colors.black),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.lime[900]),
                                                gapPadding: 1,
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        height: 100,
                                        width: 230,
                                      )
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
