import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/api/constants/constant_api.dart';
import 'package:nosso/src/core/controller/pedidoItem_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/pedidoitem.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/paginas/pedido/pedido_create_page.dart';
import 'package:nosso/src/paginas/pedidoitem/itens_page.dart';
import 'package:nosso/src/paginas/produto/produto_tab.dart';
import 'package:nosso/src/util/load/circular_progresso.dart';
import 'package:nosso/src/util/snackbar/snackbar_global.dart';
import 'package:nosso/src/util/validador/validador_pedido_item.dart';

class CaixaPageHome extends StatefulWidget {
  @override
  _CaixaPageHomeState createState() => _CaixaPageHomeState();
}

class _CaixaPageHomeState extends State<CaixaPageHome>
    with ValidadorPedidoItem {
  var produtoController = GetIt.I.get<ProdutoController>();
  var pedidoItemController = GetIt.I.get<PedidoItemController>();
  var focusScopeNode = FocusScopeNode();
  var formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

  Produto p;
  PedidoItem pedidoItem;
  var codigoBarraController = TextEditingController();
  var quantidadeController = TextEditingController();
  var valorUnitarioController = TextEditingController();
  var valorTotalController = TextEditingController();
  var descontoController = TextEditingController();
  var valorPedidoController = TextEditingController();
  var totalVolumesController = TextEditingController();
  var foto;

  Controller controller;

  @override
  void initState() {
    pedidoItemController.pedidosItens();
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

  adicionaItem(PedidoItem pedidoItem) {
    setState(() {
      if (pedidoItemController.isExisteItem(new PedidoItem(produto: p))) {
        pedidoItemController.remove(pedidoItem);
        pedidoItemController.itens;
        // pedidoItemController.adicionar(new PedidoItem(produto: p));

        showSnackbar(context, " removido");
        pedidoItemController.calculateTotal();
      } else {
        pedidoItemController.adicionar(new PedidoItem(produto: p));
        showSnackbar(context, "${p.nome} adicionado");
        double total = pedidoItemController.total;
        valorPedidoController.text = total.toStringAsFixed(2);
        pedidoItemController.calculateTotal();
      }
    });
  }

  removeItem(PedidoItem pedidoItem) {
    setState(() {
      pedidoItemController.remove(pedidoItem);
      pedidoItemController.itens;
      showSnackbar(context, "item removido");
      pedidoItemController.calculateTotal();
    });
  }

  selecionaItem(PedidoItem p) {
    codigoBarraController.text = p.produto.codigoBarra;
    quantidadeController.text = p.quantidade.toStringAsFixed(0);
    valorUnitarioController.text = p.valorUnitario.toStringAsFixed(2);
    valorTotalController.text = p.valorTotal.toStringAsFixed(2);

    print("Código de barra: ${p.produto.codigoBarra}");
    print("Descrição: ${p.produto.descricao}");
    print("Quantidade: ${p.quantidade}");
    print("Valor unitário: ${p.valorUnitario}");
    print("Valor total: ${p.valorTotal}");

    print("Foto: ${p.produto.foto}");
  }

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('dd-MM-yyyy HH:mm');

    valorPedidoController.text = pedidoItemController.total.toStringAsFixed(2);
    totalVolumesController.text = pedidoItemController.itens.length.toString();

    return Scaffold(
      key: GlobalScaffold.instance.scaffkey,
      appBar: AppBar(
        title: Text("GDADOS - PDV 2020"),
        actions: <Widget>[
          Observer(
            builder: (context) {
              if (pedidoItemController.error != null) {
                return Text("Não foi possível carregar");
              }

              if (pedidoItemController.itens == null) {
                return Center(
                  child: Icon(Icons.warning_amber_outlined),
                );
              }

              return Chip(
                label: Text(
                  (pedidoItemController.itens.length ?? 0).toString(),
                ),
              );
            },
          ),
          SizedBox(width: 20),
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                print("itens: ${pedidoItemController.itens.length}");
                pedidoItemController.pedidosItens();
              });
            },
          ),
          SizedBox(width: 20),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ItemPage();
                  },
                ),
              );
            },
          ),
          SizedBox(width: 20),
        ],
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
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.green,
                        ),
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
                                  child: p.foto == null
                                      ? Icon(Icons.photo, size: 100)
                                      : Image.network(
                                          produtoController.arquivo + p.foto,
                                        ),
                                  alignment: Alignment.center,
                                ),
                                Container(
                                  width: 380,
                                  color: Colors.grey[300],
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Código de Barra",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          TextFormField(
                                            controller: codigoBarraController,
                                            onFieldSubmitted: (valor) {
                                              if (controller.validate()) {
                                                setState(() {
                                                  codigoBarraController.text =
                                                      valor;
                                                  buscarByCodigoDeBarra(
                                                      codigoBarraController
                                                          .text);
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 30.0,
                                                      horizontal: 10.0),
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
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Quantidade",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          TextFormField(
                                            controller: quantidadeController,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                onPressed: () =>
                                                    quantidadeController
                                                        .clear(),
                                                icon: Icon(Icons.clear),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 30.0,
                                                      horizontal: 10.0),
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
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Valor Unitário",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          TextFormField(
                                            controller: valorUnitarioController,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                onPressed: () =>
                                                    valorUnitarioController
                                                        .clear(),
                                                icon: Icon(Icons.clear),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 30.0,
                                                      horizontal: 10.0),
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
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Valor Total",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          TextFormField(
                                            controller: valorTotalController,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                onPressed: () =>
                                                    valorTotalController
                                                        .clear(),
                                                icon: Icon(Icons.clear),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 30.0,
                                                      horizontal: 10.0),
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
                                      )
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
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: ListTile(
                                      title: Text("descrição"),
                                      subtitle: p.nome == null
                                          ? Text(
                                              "CAIXA VAZIO",
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
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        FlatButton.icon(
                                          minWidth: 320,
                                          height: 60,
                                          icon: Icon(Icons.delete_outline),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            side:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          color: Colors.white,
                                          textColor: Colors.grey,
                                          padding: EdgeInsets.all(10),
                                          onPressed: () {
                                            showDialogAlertCancelar(context);
                                          },
                                          label: Text(
                                            "CANCELAR".toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        FlatButton.icon(
                                          minWidth: 320,
                                          height: 60,
                                          icon: Icon(
                                              Icons.shopping_cart_outlined),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            side:
                                                BorderSide(color: Colors.green),
                                          ),
                                          color: Colors.white,
                                          textColor: Colors.green,
                                          padding: EdgeInsets.all(10),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return PedidoCreatePage();
                                                },
                                              ),
                                            );
                                          },
                                          label: Text(
                                            "FECHAR VENDA".toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
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
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.white),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              child: Text(
                                  " ===================================== CUPOM FISCAL ===================================== "),
                              alignment: Alignment.center,
                            ),
                            Divider(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.white),
                              ),
                              height: 535,
                              width: double.infinity,
                              child: builderConteudoList(),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                ),
                                height: double.infinity,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border: Border.all(color: Colors.white),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 300,
                                            child: ListTile(
                                              title: Text("Volumes"),
                                              subtitle: TextFormField(
                                                controller:
                                                    totalVolumesController,
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
                                            child: ListTile(
                                              title: Text("Desconto"),
                                              subtitle: TextFormField(
                                                controller: descontoController,
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
                                          ),
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

  builderConteudoList() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<PedidoItem> itens = pedidoItemController.itens;
          if (pedidoItemController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (itens == null) {
            return CircularProgressor();
          }

          if (itens.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.shopping_basket,
                      color: Colors.green,
                      size: 100,
                    ),
                  ),
                  Text("Sua cesta está vazia"),
                  SizedBox(height: 20),
                  RaisedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProdutoTab();
                          },
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: BorderSide(color: Colors.blue),
                    ),
                    color: Colors.white,
                    textColor: Colors.green,
                    padding: EdgeInsets.all(10),
                    icon: Icon(
                      Icons.home,
                      color: Colors.blue,
                    ),
                    label: Text(
                      "ESCOLHER PRODUTOS",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    elevation: 0,
                  ),
                ],
              ),
            );
          }

          return builderTable(itens);
        },
      ),
    );
  }

  builderTable(List<PedidoItem> itens) {
    return DataTable(
      sortAscending: true,
      showCheckboxColumn: true,
      showBottomBorder: true,
      columns: [
        DataColumn(label: Text("Código")),
        DataColumn(label: Text("Quantidade")),
        DataColumn(label: Text("Valor Unit.")),
        DataColumn(label: Text("Descrição")),
        DataColumn(label: Text("Valor Total")),
        DataColumn(label: Text("Excluir"))
      ],
      rows: itens
          .map(
            (p) => DataRow(
              onSelectChanged: (i) {
                setState(() {
                  selecionaItem(p);
                });
              },
              cells: [
                DataCell(
                  Text("${p.produto.id}"),
                ),
                DataCell(
                  Text("${p.quantidade}"),
                ),
                DataCell(
                  Text(
                    "R\$ ${formatMoeda.format(p.valorUnitario)}",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                DataCell(Text(p.produto.nome)),
                DataCell(
                  Text(
                    "R\$ ${formatMoeda.format(p.valorTotal)}",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () {
                      showDialogAlertExcluir(context, p);
                    },
                  ),
                )
              ],
            ),
          )
          .toList(),
    );
  }

  showDialogAlertExcluir(BuildContext context, PedidoItem p) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Deseja remover este item?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${p.produto.nome}"),
                Text("Cod: ${p.produto.id}"),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      ConstantApi.urlArquivoProduto + p.produto.foto,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton.icon(
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
              label: Text('CANCELAR'),
              color: Colors.white,
              elevation: 0,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton.icon(
              icon: Icon(
                Icons.restore_from_trash,
                color: Colors.green,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.green),
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
              label: Text('EXCLUIR'),
              color: Colors.white,
              elevation: 0,
              onPressed: () {
                setState(() {
                  pedidoItemController.remove(p);
                  pedidoItemController.itens;
                });

                // showSnackbar(context, "Produto ${p.produto.nome} removido");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showDialogAlertCancelar(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.all(10),
          title: Text(
            "Deseja cancelar esta venda?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Icon(
                    Icons.mood_bad_outlined,
                    size: 100,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton.icon(
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
              label: Text('NÃO'),
              color: Colors.white,
              elevation: 0,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton.icon(
              icon: Icon(
                Icons.restore_from_trash,
                color: Colors.green,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.green),
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
              label: Text('SIM'),
              color: Colors.white,
              elevation: 0,
              onPressed: () {
                setState(() {
                  pedidoItemController.itens.clear();
                  pedidoItemController.itens;
                  valorPedidoController.clear();
                  pedidoItem = new PedidoItem(produto: new Produto());
                });

                // showSnackbar(context, "Produto ${p.produto.nome} removido");
                Navigator.of(context).pop();
              },
            ),
          ],
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
