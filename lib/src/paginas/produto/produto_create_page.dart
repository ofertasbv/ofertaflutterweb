import 'dart:async';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:brasil_fields/formatter/real_input_formatter.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/cor_controller.dart';
import 'package:nosso/src/core/controller/marca_controller.dart';
import 'package:nosso/src/core/controller/promocao_controller.dart';
import 'package:nosso/src/core/controller/subcategoria_controller.dart';
import 'package:nosso/src/core/controller/loja_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/controller/tamanho_controller.dart';
import 'package:nosso/src/core/model/cor.dart';
import 'package:nosso/src/core/model/estoque.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/core/model/marca.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/core/model/promocao.dart';
import 'package:nosso/src/core/model/subcategoria.dart';
import 'package:nosso/src/core/model/tamanho.dart';
import 'package:nosso/src/paginas/produto/produto_page.dart';
import 'package:nosso/src/util/dialogs/dialogs.dart';
import 'package:nosso/src/util/load/circular_progresso_mini.dart';

class ProdutoCreatePage extends StatefulWidget {
  Produto produto;

  ProdutoCreatePage({Key key, this.produto}) : super(key: key);

  @override
  _ProdutoCreatePageState createState() =>
      _ProdutoCreatePageState(p: this.produto);
}

class _ProdutoCreatePageState extends State<ProdutoCreatePage> {
  _ProdutoCreatePageState({this.p});

  ProdutoController produtoController = GetIt.I.get<ProdutoController>();
  SubCategoriaController subCategoriaController =
      GetIt.I.get<SubCategoriaController>();
  LojaController lojaController = GetIt.I.get<LojaController>();
  MarcaController marcaController = GetIt.I.get<MarcaController>();
  PromoCaoController promocaoController = GetIt.I.get<PromoCaoController>();
  TamanhoController tamanhoController = GetIt.I.get<TamanhoController>();
  CorController corController = GetIt.I.get<CorController>();

  List<Tamanho> tamanhoSelecionada = List();
  List<Cor> corSelecionada = List();

  Dialogs dialogs = Dialogs();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<SubCategoria>> subCategorias;
  Future<List<Marca>> marcas;
  Future<List<Promocao>> promocoes;
  Future<List<Loja>> lojas;
  Future<List<Tamanho>> tamanhos;
  Future<List<Cor>> cores;

  Produto p;
  Estoque e;

  SubCategoria subCategoriaSelecionada;
  Loja lojaSelecionada;
  Promocao promocaoSelecionada;
  Marca marcaSelecionada;

  Controller controller;
  TextEditingController controllerCodigoBarra = TextEditingController();
  TextEditingController quantidadeController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController descontoController = TextEditingController();

  String barcode = "";
  bool clicadoTamanho = false;
  bool clicadoCor = false;

  bool favorito;
  bool novo;
  bool status;
  bool destaque;

  double desconto;
  double valor;
  int quantidade;

  String medida;
  String tamanho;
  String origem;

  File file;

  @override
  void initState() {
    if (p == null) {
      p = Produto();
      e = Estoque();

      favorito = false;
      novo = false;
      status = false;
      destaque = false;

      medida = "UNIDADE";
      tamanho = "PEQUENO";
      origem = "NACIONAL";
    } else {
      e = p.estoque;

      favorito = p.favorito;
      novo = p.novo;
      status = p.status;
      destaque = p.destaque;
    }

    lojas = lojaController.getAll();
    subCategorias = subCategoriaController.getAll();
    marcas = marcaController.getAll();
    promocoes = promocaoController.getAll();
    tamanhos = tamanhoController.getAll();
    cores = corController.getAll();

    produtoController.getAll();

    p.estoque = e;

    lojaSelecionada = p.loja;
    subCategoriaSelecionada = p.subCategoria;
    marcaSelecionada = p.marca;
    promocaoSelecionada = p.promocao;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  executar(String nomeAudio) {}

  barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        executar("beep-07");
        this.barcode = barcode;
        controllerCodigoBarra.text = this.barcode;
      });
    } on FormatException {
      setState(() => this.barcode = 'Nada capturado.');
    } catch (e) {
      setState(() => this.barcode = 'Erros: $e');
    }
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
      FormData url = await produtoController.upload(file, p.foto);
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
        title: Text("Produto cadastros"),
      ),
      body: Observer(
        builder: (context) {
          if (produtoController.dioError == null) {
            return buildListViewForm(context);
          } else {
            print("Erro: ${produtoController.mensagem}");
            showToast("${produtoController.mensagem}");
            return buildListViewForm(context);
          }
        },
      ),
    );
  }

  buildListViewForm(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    NumberFormat formatter = NumberFormat("00.00");
    double initialValue = num.parse(0.18941.toStringAsPrecision(2));
    double value = 0.19;

    NumberFormat formata = new NumberFormat("#,##0.00", "pt_BR");

    quantidadeController.text = p.estoque.quantidade.toString();
    valorController.text = p.estoque.valor.toString();
    descontoController.text = p.desconto.toString();

    valor = 0.0;
    desconto = 0.0;
    quantidade = 1;

    print(formatter.format(initialValue));
    print(formatter.format(value));

    return ListView(
      children: <Widget>[
        Container(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                /* ================ Pequisa codigo de barra ================ */
                Card(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          initialValue: p.codigoBarra,
                          controller: p.codigoBarra == null
                              ? controllerCodigoBarra
                              : null,
                          onSaved: (value) => p.codigoBarra = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.grey,
                            ),
                            labelText:
                                "Entre com código de barra ou clique (scanner)",
                            hintText: "Código de barra",
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lime[900]),
                              gapPadding: 1,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 20,
                        ),
                        RaisedButton.icon(
                          elevation: 0.0,
                          icon: Icon(Icons.photo_camera_outlined),
                          label: Text("Scanner"),
                          onPressed: () {
                            barcodeScanning();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                /* ================ Cadastro produto ================ */
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
                            hintText: "nome produto",
                            prefixIcon: Icon(
                              Icons.shopping_cart,
                              color: Colors.grey,
                            ),
                            suffixIcon: Icon(Icons.close),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lime[900]),
                              gapPadding: 1,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
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
                            hintText: "descrição produto",
                            prefixIcon: Icon(
                              Icons.description,
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
                          keyboardType: TextInputType.text,
                          maxLength: 100,
                          maxLines: null,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          initialValue: p.sku,
                          onSaved: (value) => p.sku = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "SKU",
                            hintText: "sku produto",
                            prefixIcon: Icon(
                              Icons.shopping_cart,
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
                          keyboardType: TextInputType.text,
                          maxLength: 100,
                          maxLines: 1,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          initialValue: p.estoque.quantidade == null
                              ? quantidade.toString()
                              : p.estoque.quantidade.toStringAsFixed(1),
                          onSaved: (value) {
                            p.estoque.quantidade = int.tryParse(value);
                          },
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Quantidade",
                            hintText: "quantidade",
                            prefixIcon: Icon(
                              Icons.mode_edit,
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
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          maxLength: 6,
                        ),
                        TextFormField(
                          initialValue: p.estoque.valor == null
                              ? valor.toString()
                              : p.estoque.valor.toStringAsFixed(2),
                          onSaved: (value) =>
                              p.estoque.valor = double.tryParse(value),
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Valor",
                            hintText: "R\$ ",
                            prefixIcon: Icon(
                              Icons.monetization_on,
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
                          maxLength: 10,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            RealInputFormatter(centavos: true)
                          ],
                        ),
                        TextFormField(
                          initialValue: p.desconto == null
                              ? desconto.toString()
                              : p.desconto.toStringAsFixed(1),
                          onSaved: (value) =>
                              p.desconto = double.tryParse(value),
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Desconto",
                            hintText: "R\$ ",
                            prefixIcon: Icon(
                              Icons.money,
                              color: Colors.grey,
                            ),
                            suffixIcon: Icon(Icons.close),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lime[900]),
                              gapPadding: 1,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            RealInputFormatter(centavos: true)
                          ],
                        ),
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
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListTile(
                        title: Text("Categoria *"),
                        subtitle: subCategoriaSelecionada == null
                            ? Text("Selecione uma categoria")
                            : Text(subCategoriaSelecionada.nome),
                        leading: Icon(Icons.list_alt_outlined),
                        trailing: Icon(Icons.arrow_drop_down_sharp),
                        onTap: () {
                          alertSelectSubCategorias(
                              context, subCategoriaSelecionada);
                        },
                      ),
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
                        title: Text("Marca *"),
                        subtitle: marcaSelecionada == null
                            ? Text("Selecione uma marca")
                            : Text(marcaSelecionada.nome),
                        leading: Icon(Icons.list_alt_outlined),
                        trailing: Icon(Icons.arrow_drop_down_sharp),
                        onTap: () {
                          alertSelectMarcas(context, marcaSelecionada);
                        },
                      ),
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
                Card(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListTile(
                        title: Text("Promoção *"),
                        subtitle: promocaoSelecionada == null
                            ? Text("Selecione uma promoção")
                            : Text(promocaoSelecionada.nome),
                        leading: Icon(Icons.list_alt_outlined),
                        trailing: Icon(Icons.arrow_drop_down_sharp),
                        onTap: () {
                          alertSelectPromocao(context, promocaoSelecionada);
                        },
                      ),
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
                      child: Column(
                        children: <Widget>[
                          Text("Configurações do sistema"),
                          SwitchListTile(
                            autofocus: true,
                            title: Text("Produto Favorito? "),
                            subtitle: Text("sim/não"),
                            value: p.favorito = favorito,
                            secondary: const Icon(Icons.check_outlined),
                            onChanged: (bool valor) {
                              setState(() {
                                favorito = valor;
                                print("resultado: " + p.favorito.toString());
                              });
                            },
                          ),
                          SizedBox(height: 30),
                          SwitchListTile(
                            autofocus: true,
                            title: Text("Produto novo? "),
                            subtitle: Text("sim/não"),
                            value: p.novo = novo,
                            secondary: const Icon(Icons.check_outlined),
                            onChanged: (bool valor) {
                              setState(() {
                                novo = valor;
                                print("resultado: " + p.novo.toString());
                              });
                            },
                          ),
                          SizedBox(height: 30),
                          SwitchListTile(
                            subtitle: Text("sim/não"),
                            title: Text("Produto Disponível?"),
                            value: p.status = status,
                            secondary: const Icon(Icons.check_outlined),
                            onChanged: (bool valor) {
                              setState(() {
                                status = valor;
                                print("resultado: " + p.status.toString());
                              });
                            },
                          ),
                          SizedBox(height: 30),
                          SwitchListTile(
                            autofocus: true,
                            subtitle: Text("sim/não"),
                            title: Text("Produto destaque?"),
                            value: p.destaque = destaque,
                            secondary: const Icon(Icons.check_outlined),
                            onChanged: (bool valor) {
                              setState(() {
                                destaque = valor;
                                print("resultado: " + p.destaque.toString());
                              });
                            },
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Unidade de medida"),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("UNIDADE"),
                                value: "UNIDADE",
                                groupValue:
                                    p.medida == null ? medida : p.medida,
                                secondary: const Icon(Icons.check_outlined),
                                onChanged: (String valor) {
                                  setState(() {
                                    p.medida = valor;
                                    print("resultado: " + p.medida);
                                  });
                                },
                              ),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("PEÇA"),
                                value: "PECA",
                                groupValue:
                                    p.medida == null ? medida : p.medida,
                                secondary: const Icon(Icons.check_outlined),
                                onChanged: (String valor) {
                                  setState(() {
                                    p.medida = valor;
                                    print("resultado: " + p.medida);
                                  });
                                },
                              ),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("QUILOGRAMA"),
                                value: "QUILOGRAMA",
                                groupValue:
                                    p.medida == null ? medida : p.medida,
                                secondary: const Icon(Icons.check_outlined),
                                onChanged: (String valor) {
                                  setState(() {
                                    p.medida = valor;
                                    print("resultado: " + p.medida);
                                  });
                                },
                              ),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("OUTRO"),
                                value: "OUTRO",
                                groupValue:
                                    p.medida == null ? medida : p.medida,
                                secondary: const Icon(Icons.check_outlined),
                                onChanged: (String valor) {
                                  setState(() {
                                    p.medida = valor;
                                    print("resultado: " + p.medida);
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
                              Text("Origem do produto"),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("NACIONAL"),
                                value: "NACIONAL",
                                groupValue:
                                    p.origem == null ? origem : p.origem,
                                secondary: const Icon(Icons.check_outlined),
                                onChanged: (String valor) {
                                  setState(() {
                                    p.origem = valor;
                                    print("resultado: " + p.origem);
                                  });
                                },
                              ),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("INTERNACIONAL"),
                                value: "INTERNACIONAL",
                                groupValue:
                                    p.origem == null ? origem : p.origem,
                                secondary: const Icon(Icons.check_outlined),
                                onChanged: (String valor) {
                                  setState(() {
                                    p.origem = valor;
                                    print("resultado: " + p.origem);
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
                  child: ExpansionTile(
                    leading: Icon(Icons.format_size_outlined),
                    title: Text("Tamanho"),
                    children: [
                      Container(
                        height: 400,
                        padding: EdgeInsets.all(10),
                        child: buildObserverTamanhos(),
                      ),
                    ],
                  ),
                ),

                Card(
                  child: ExpansionTile(
                    leading: Icon(Icons.color_lens_outlined),
                    title: Text("Cores"),
                    children: [
                      Container(
                        height: 400,
                        padding: EdgeInsets.all(10),
                        child: buildObserverCores(),
                      ),
                    ],
                  ),
                ),

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
                                    fit: BoxFit.fitWidth,
                                  )
                                : p.foto != null
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                          ConstantApi.urlArquivoProduto +
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
        Card(
          child: Container(
            child: RaisedButton.icon(
              label: Text("Enviar formulário"),
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () {
                if (controller.validate()) {
                  if (p.id == null) {
                    if (p.foto == null) {
                      showToast("deve anexar uma foto!");
                    }
                    Timer(Duration(seconds: 3), () {
                      p.estoque.quantidade = quantidade;
                      p.estoque.valor = valor;
                      p.desconto = desconto;

                      p.loja = lojaSelecionada;
                      p.subCategoria = subCategoriaSelecionada;
                      p.marca = marcaSelecionada;
                      p.promocao = promocaoSelecionada;
                      produtoController.create(p);

                      Navigator.of(context).pop();
                      buildPush(context);
                    });
                  } else {
                    Timer(Duration(seconds: 3), () {
                      p.loja = lojaSelecionada;
                      p.subCategoria = subCategoriaSelecionada;
                      p.marca = marcaSelecionada;
                      p.promocao = promocaoSelecionada;
                      produtoController.update(p.id, p);

                      Navigator.of(context).pop();
                      buildPush(context);
                    });
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  buildPush(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProdutoPage(),
      ),
    );
  }

  /* ===================  MARCA LISTA ===================  */
  alertSelectMarcas(BuildContext context, Marca c) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: builderConteudoListMarca(),
          ),
        );
      },
    );
  }

  builderConteudoListMarca() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Marca> marcas = marcaController.marcas;
          if (marcaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (marcas == null) {
            return CircularProgressorMini();
          }

          return builderListMarcas(marcas);
        },
      ),
    );
  }

  builderListMarcas(List<Marca> marcas) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.builder(
      itemCount: marcas.length,
      itemBuilder: (context, index) {
        Marca c = marcas[index];

        return Column(
          children: [
            GestureDetector(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.shopping_bag_outlined),
                ),
                title: Text(c.nome),
              ),
              onTap: () {
                setState(() {
                  marcaSelecionada = c;
                  print("${marcaSelecionada.nome}");
                });
                Navigator.of(context).pop();
              },
            ),
            Divider()
          ],
        );
      },
    );
  }

  /* ===================  SUBCATEGORIA LISTA ===================  */
  alertSelectSubCategorias(BuildContext context, SubCategoria c) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: builderConteudoListSubCategorias(),
          ),
        );
      },
    );
  }

  builderConteudoListSubCategorias() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<SubCategoria> subCategorias =
              subCategoriaController.subCategorias;
          if (subCategoriaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (subCategorias == null) {
            return CircularProgressorMini();
          }

          return builderListSubCategorias(subCategorias);
        },
      ),
    );
  }

  builderListSubCategorias(List<SubCategoria> subCategorias) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.builder(
      itemCount: subCategorias.length,
      itemBuilder: (context, index) {
        SubCategoria c = subCategorias[index];

        return Column(
          children: [
            GestureDetector(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 30,
                  child: Icon(Icons.check_outlined),
                ),
                title: Text(c.nome),
              ),
              onTap: () {
                setState(() {
                  subCategoriaSelecionada = c;
                  print("${subCategoriaSelecionada.nome}");
                });
                Navigator.of(context).pop();
              },
            ),
            Divider()
          ],
        );
      },
    );
  }

  /* ===================  SUBCATEGORIA LOJA ===================  */
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
            child: builderConteudoListLojas(),
          ),
        );
      },
    );
  }

  builderConteudoListLojas() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Loja> lojas = lojaController.lojas;
          if (lojaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (lojas == null) {
            return CircularProgressorMini();
          }

          return builderListLojas(lojas);
        },
      ),
    );
  }

  builderListLojas(List<Loja> lojas) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.builder(
      itemCount: lojas.length,
      itemBuilder: (context, index) {
        Loja c = lojas[index];

        return Column(
          children: [
            GestureDetector(
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
            ),
            Divider()
          ],
        );
      },
    );
  }

  /* ===================  PROMOÇÃO LISTA ===================  */
  alertSelectPromocao(BuildContext context, Promocao c) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: builderConteudoListPromocao(),
          ),
        );
      },
    );
  }

  builderConteudoListPromocao() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Promocao> promocoes = promocaoController.promocoes;
          if (promocaoController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (promocoes == null) {
            return CircularProgressorMini();
          }

          return builderListPromocoes(promocoes);
        },
      ),
    );
  }

  builderListPromocoes(List<Promocao> promocoes) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.builder(
      itemCount: promocoes.length,
      itemBuilder: (context, index) {
        Promocao c = promocoes[index];

        return Column(
          children: [
            GestureDetector(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "${ConstantApi.urlArquivoPromocao + c.foto}",
                  ),
                ),
                title: Text(c.nome),
              ),
              onTap: () {
                setState(() {
                  promocaoSelecionada = c;
                  print("${promocaoSelecionada.nome}");
                });
                Navigator.of(context).pop();
              },
            ),
            Divider()
          ],
        );
      },
    );
  }

  /* ===================  TAMANHO LISTA ===================  */

  onSelected(bool selected, Tamanho tamanho) {
    if (selected == true) {
      setState(() {
        tamanhoSelecionada.add(tamanho);
      });
    } else {
      setState(() {
        tamanhoSelecionada.remove(tamanho);
      });
    }
  }

  alertSelectTamanhos(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: buildObserverTamanhos(),
          ),
        );
      },
    );
  }

  buildObserverTamanhos() {
    return Observer(
      builder: (context) {
        List<Tamanho> tamanhos = tamanhoController.tamanhos;
        if (tamanhoController.error != null) {
          return Text("Não foi possível carregados dados");
        }

        if (tamanhos == null) {
          return CircularProgressorMini();
        }

        return builderList(tamanhos);
      },
    );
  }

  builderList(List<Tamanho> tamanhos) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.separated(
      itemCount: tamanhos.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        Tamanho c = tamanhos[index];

        return CheckboxListTile(
          value: tamanhoSelecionada.contains(tamanhos[index]),
          onChanged: (bool select) {
            clicadoTamanho = select;
            onSelected(clicadoTamanho, c);
            print("Clicado: ${clicadoTamanho} - ${c.descricao}");
            for (Tamanho t in tamanhoSelecionada) {
              print("Lista: ${t.descricao}");
            }
          },
          title: Text("${c.descricao}"),
        );
      },
    );
  }

  /* ===================  TAMANHO LISTA ===================  */

  onSelectedCor(bool selected, Cor cor) {
    if (selected == true) {
      setState(() {
        corSelecionada.add(cor);
      });
    } else {
      setState(() {
        corSelecionada.remove(cor);
      });
    }
  }

  alertSelectCor(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: buildObserverCores(),
          ),
        );
      },
    );
  }

  buildObserverCores() {
    return Observer(
      builder: (context) {
        List<Cor> cores = corController.cores;
        if (corController.error != null) {
          return Text("Não foi possível carregados dados");
        }

        if (cores == null) {
          return CircularProgressorMini();
        }

        return builderListCor(cores);
      },
    );
  }

  builderListCor(List<Cor> cores) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.separated(
      itemCount: cores.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        Cor c = cores[index];

        return CheckboxListTile(
          value: corSelecionada.contains(cores[index]),
          onChanged: (bool select) {
            clicadoCor = select;
            onSelectedCor(clicadoCor, c);
            print("Clicado: ${clicadoCor} - ${c.descricao}");
            for (Cor c in corSelecionada) {
              print("Lista: ${c.descricao}");
            }
          },
          title: Text("${c.descricao}"),
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
