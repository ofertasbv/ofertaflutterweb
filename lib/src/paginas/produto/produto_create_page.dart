import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:brasil_fields/formatter/real_input_formatter.dart';
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
import 'package:nosso/src/core/controller/marca_controller.dart';
import 'package:nosso/src/core/controller/promocao_controller.dart';
import 'package:nosso/src/core/controller/subcategoria_controller.dart';
import 'package:nosso/src/core/controller/loja_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/estoque.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/core/model/marca.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/core/model/promocao.dart';
import 'package:nosso/src/core/model/subcategoria.dart';
import 'package:nosso/src/core/repository/produto_repository.dart';
import 'package:nosso/src/util/converter/thousandsFormatter.dart';

class ProdutoCreatePage extends StatefulWidget {
  Produto produto;

  ProdutoCreatePage({Key key, this.produto}) : super(key: key);

  @override
  _ProdutoCreatePageState createState() =>
      _ProdutoCreatePageState(p: this.produto);
}

class _ProdutoCreatePageState extends State<ProdutoCreatePage> {
  ProdutoController produtoController = GetIt.I.get<ProdutoController>();
  SubCategoriaController subCategoriaController =
      GetIt.I.get<SubCategoriaController>();
  LojaController lojaController = GetIt.I.get<LojaController>();
  MarcaController marcaController = GetIt.I.get<MarcaController>();
  PromoCaoController promocaoController = GetIt.I.get<PromoCaoController>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<SubCategoria>> subCategorias;
  Future<List<Marca>> marcas;
  Future<List<Promocao>> promocoes;
  Future<List<Loja>> lojas;

  Produto p;
  Estoque e;

  SubCategoria subCategoriaSelecionada;
  Loja lojaSelecionada;
  Promocao promocaoSelecionada;
  Marca marcaSelecionada;

  _ProdutoCreatePageState({this.p});

  Controller controller;
  var controllerCodigoBarra = TextEditingController();

  // AudioCache audioCache = AudioCache(prefix: "audios/");
  String barcode = "";

  bool favorito = false;
  bool novo = false;
  bool status = true;
  bool destaque = false;
  String unidade;
  File file;

  @override
  void initState() {
    if (p == null) {
      p = Produto();
      e = Estoque();
    } else {
      e = p.estoque;
    }

    lojas = lojaController.getAll();
    subCategorias = subCategoriaController.getAll();
    marcas = marcaController.getAll();
    promocoes = promocaoController.getAll();

    produtoController.getAll();
    // audioCache.loadAll(["beep-07.mp3"]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  executar(String nomeAudio) {
    // audioCache.play(nomeAudio + ".mp3");
  }

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
      var atual = DateTime.now();
      setState(() {
        this.file = f;
        String arquivo = file.path.split('/').last;
        String filePath = arquivo.replaceAll(
            "$arquivo", "produto-" + atual.toString() + ".png");
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
            "$arquivo", "produto-" + atual.toString() + ".png");
        print("arquivo: $arquivo");
        print("filePath: $filePath");
        p.foto = filePath;
      });
    }
  }

  onClickUpload() async {
    if (file != null) {
      var url = await ProdutoRepository.upload(file, p.foto);
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

  showToast(String cardTitle) {
    Fluttertoast.showToast(
      msg: "$cardTitle",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.indigo,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    p.estoque = e;
    p.loja = lojaSelecionada;
    p.subCategoria = subCategoriaSelecionada;
    p.marca = marcaSelecionada;
    p.promocao = promocaoSelecionada;

    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    NumberFormat formatter = NumberFormat("00.00");
    double initialValue = num.parse(0.18941.toStringAsPrecision(2));
    double value = 0.19;

    final formata = new NumberFormat("#,##0.00", "pt_BR");

    print(formatter.format(initialValue));
    print(formatter.format(value));

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Produto cadastros"),
      ),
      body: Observer(
        builder: (context) {
          if (produtoController.error != null) {
            return Text("Não foi possível cadastrar produto");
          } else {
            return ListView(
              children: <Widget>[
                Container(
                  child: Form(
                    key: controller.formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
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
                                    prefixIcon: Icon(Icons.camera_alt_outlined),
                                    suffixIcon: Icon(Icons.close),
                                    labelText:
                                        "Entre com código de barra ou clique (scanner)",
                                    hintText: "Código de barra",
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
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
                                    prefixIcon: Icon(Icons.shopping_cart),
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
                                    hintText: "descrição produto",
                                    prefixIcon: Icon(Icons.description),
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
                                SizedBox(height: 20),
                                TextFormField(
                                  initialValue: p.sku,
                                  onSaved: (value) => p.sku = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "SKU",
                                    hintText: "sku produto",
                                    prefixIcon: Icon(Icons.shopping_cart),
                                    suffixIcon: Icon(Icons.close),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 100,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  initialValue: p.cor,
                                  onSaved: (value) => p.cor = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Cor",
                                    hintText: "cor produto",
                                    prefixIcon: Icon(Icons.shopping_cart),
                                    suffixIcon: Icon(Icons.close),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 100,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  onSaved: (value) {
                                    p.estoque.quantidade = int.tryParse(value);
                                  },
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Quantidade",
                                    hintText: "quantidade",
                                    prefixIcon: Icon(Icons.mode_edit),
                                    suffixIcon: Icon(Icons.close),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: false, signed: false),
                                  maxLength: 6,
                                ),
                                TextFormField(
                                  onSaved: (value) =>
                                      p.estoque.valor = double.tryParse(value),
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Valor",
                                    hintText: "R\$ ",
                                    prefixIcon: Icon(Icons.monetization_on),
                                    suffixIcon: Icon(Icons.close),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    RealInputFormatter(centavos: true)
                                  ],
                                ),
                                TextFormField(
                                  onSaved: (value) =>
                                      p.desconto = double.tryParse(value),
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Desconto",
                                    hintText: "R\$ ",
                                    prefixIcon: Icon(Icons.money),
                                    suffixIcon: Icon(Icons.close),
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
                            child: Column(
                              children: <Widget>[
                                SwitchListTile(
                                  autofocus: true,
                                  title: Text("Produto Favorito? "),
                                  subtitle: Text("sim/não"),
                                  value: p.favorito = favorito,
                                  onChanged: (bool valor) {
                                    setState(() {
                                      favorito = valor;
                                      print(
                                          "resultado: " + favorito.toString());
                                    });
                                  },
                                ),
                                SizedBox(height: 30),
                                SwitchListTile(
                                  autofocus: true,
                                  title: Text("Produto novo? "),
                                  subtitle: Text("sim/não"),
                                  value: p.novo = novo,
                                  onChanged: (bool valor) {
                                    setState(() {
                                      novo = valor;
                                      print("resultado: " + novo.toString());
                                    });
                                  },
                                ),
                                SizedBox(height: 30),
                                SwitchListTile(
                                  subtitle: Text("sim/não"),
                                  title: Text("Produto Disponível?"),
                                  value: p.status = status,
                                  onChanged: (bool valor) {
                                    setState(() {
                                      status = valor;
                                      print("resultado: " + status.toString());
                                    });
                                  },
                                ),
                                SizedBox(height: 30),
                                SwitchListTile(
                                  autofocus: true,
                                  subtitle: Text("sim/não"),
                                  title: Text("Produto destaque?"),
                                  value: p.destaque = destaque,
                                  onChanged: (bool valor) {
                                    setState(() {
                                      destaque = valor;
                                      print(
                                          "resultado: " + destaque.toString());
                                    });
                                  },
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Unidade de medida",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    RadioListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      title: Text("UNIDADE"),
                                      value: "UNIDADE",
                                      groupValue: p.medida,
                                      selected: true,
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
                                      groupValue: p.medida,
                                      selected: true,
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
                                      groupValue: p.medida,
                                      selected: true,
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
                                      groupValue: p.medida,
                                      selected: true,
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
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Tamanho do produto",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    RadioListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      title: Text("PEQUENO"),
                                      value: "PEQUENO",
                                      groupValue: p.tamanho,
                                      selected: true,
                                      onChanged: (String valor) {
                                        setState(() {
                                          p.tamanho = valor;
                                          print("resultado: " + p.tamanho);
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      title: Text("MEDIO"),
                                      value: "MEDIO",
                                      groupValue: p.tamanho,
                                      selected: true,
                                      onChanged: (String valor) {
                                        setState(() {
                                          p.tamanho = valor;
                                          print("resultado: " + p.tamanho);
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      title: Text("GRANDE"),
                                      value: "GRANDE",
                                      groupValue: p.tamanho,
                                      selected: true,
                                      onChanged: (String valor) {
                                        setState(() {
                                          p.tamanho = valor;
                                          print("resultado: " + p.tamanho);
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      title: Text("OUTRO"),
                                      value: "OUTRO",
                                      groupValue: p.tamanho,
                                      selected: true,
                                      onChanged: (String valor) {
                                        setState(() {
                                          p.tamanho = valor;
                                          print("resultado: " + p.tamanho);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Origem do produto",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    RadioListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      title: Text("NACIONAL"),
                                      value: "NACIONAL",
                                      groupValue: p.origem,
                                      selected: true,
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
                                      groupValue: p.origem,
                                      selected: true,
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
                        Card(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: <Widget>[
                                FutureBuilder<List<SubCategoria>>(
                                  future: subCategorias,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return DropdownButtonFormField<
                                          SubCategoria>(
                                        validator: (value) => value == null
                                            ? 'campo obrigatório'
                                            : null,
                                        value: subCategoriaSelecionada,
                                        items: snapshot.data.map((categoria) {
                                          return DropdownMenuItem<SubCategoria>(
                                            value: categoria,
                                            child: Text(categoria.nome),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          labelText: "Categoria",
                                          filled: true,
                                          fillColor: Colors.white,
                                          prefixIcon:
                                              Icon(Icons.list_alt_outlined),
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
                                        onChanged: (SubCategoria c) {
                                          setState(() {
                                            subCategoriaSelecionada = c;
                                            print(subCategoriaSelecionada.nome);
                                          });
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("${snapshot.error}");
                                    }

                                    return Text(
                                        "não foi peossível carregar subCategorias");
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
                                FutureBuilder<List<Marca>>(
                                  future: marcas,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return DropdownButtonFormField<Marca>(
                                        validator: (value) => value == null
                                            ? 'campo obrigatório'
                                            : null,
                                        value: marcaSelecionada,
                                        items: snapshot.data.map((marca) {
                                          return DropdownMenuItem<Marca>(
                                            value: marca,
                                            child: Text(marca.nome),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          labelText: "Marca",
                                          filled: true,
                                          fillColor: Colors.white,
                                          prefixIcon: Icon(Icons.shopping_bag),
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
                                        onChanged: (Marca c) {
                                          setState(() {
                                            marcaSelecionada = c;
                                            print(marcaSelecionada.nome);
                                          });
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("${snapshot.error}");
                                    }

                                    return Text(
                                        "não foi peossível carregar marcas");
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
                                            ? 'campo obrigatório'
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
                                          prefixIcon: Icon(Icons
                                              .local_convenience_store_outlined),
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
                                        "não foi peossível carregar lojs");
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                FutureBuilder<List<Promocao>>(
                                  future: promocoes,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return DropdownButtonFormField<Promocao>(
                                        validator: (value) => value == null
                                            ? 'campo obrigatório'
                                            : null,
                                        value: promocaoSelecionada,
                                        items: snapshot.data.map((promocao) {
                                          return DropdownMenuItem<Promocao>(
                                            value: promocao,
                                            child: Text(promocao.nome),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          labelText: "Oferta",
                                          filled: true,
                                          fillColor: Colors.white,
                                          prefixIcon: Icon(Icons.add_alert),
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
                                        onChanged: (Promocao c) {
                                          setState(() {
                                            promocaoSelecionada = c;
                                            print(promocaoSelecionada.nome);
                                          });
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("${snapshot.error}");
                                    }

                                    return Text(
                                        "não foi peossível carregar ofertas");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                          ? () =>
                                              lojaController.deleteFoto(p.foto)
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
                        Card(
                          child: GestureDetector(
                            onTap: () {
                              openBottomSheet(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
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
                                              child: Image.network(
                                                ConstantApi.urlArquivoProduto +
                                                    p.foto,
                                                fit: BoxFit.fill,
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
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    label: Text(
                      "Enviar formuário",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    textColor: Colors.white,
                    splashColor: Colors.red,
                    color: Colors.black,
                    onPressed: () {
                      if (controller.validate()) {
                        if (p.foto == null) {
                          showToast("deve anexar uma foto!");
                        } else {
                          onClickUpload();
                          produtoController.create(p);
                          //
                          // Navigator.of(context).pop();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ProdutoPage(),
                          //   ),
                          // );
                        }
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

  changeCategorias(SubCategoria s) {
    setState(() {
      subCategoriaSelecionada = s;
      print("SubCategoria.:  ${subCategoriaSelecionada.nome}");
    });
  }

  changePessoas(Loja p) {
    setState(() {
      lojaSelecionada = p;
      print("Loja.:  ${lojaSelecionada.id}");
    });
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
