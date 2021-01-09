import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/paginas/produto/produto_detalhes_tab.dart';

class LeitorCodigoBarra extends StatefulWidget {
  @override
  _LeitorCodigoBarraState createState() => new _LeitorCodigoBarraState();
}

class _LeitorCodigoBarraState extends State<LeitorCodigoBarra> {
  ProdutoController produtoController = GetIt.I.get<ProdutoController>();

  String barcode = "";
  var p = Produto();
  var codigoBarraController = TextEditingController();
  var descricaoController = TextEditingController();

  // AudioPlayer audioPlayer = AudioPlayer();
  // AudioCache audioCache = AudioCache();

  @override
  initState() {
    super.initState();
  }

  Controller controller;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  void showErrorSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Oops... the URL couldn\'t be opened!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    p.codigoBarra = barcode;
    print("construindo tela: " + p.codigoBarra);
    return Scaffold(
      appBar: AppBar(
        title: Text('Leitor código de barra'),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (codigoBarraController.text.isNotEmpty && p != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProdutoDetalhesTab(p);
                    },
                  ),
                );
              } else {
                showToast("Insira o código de barra!");
                print("nada");
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff676B76), Color(0xffA0A4AE)],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff676B76).withOpacity(0.4),
                    blurRadius: 40,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      autofocus: false,
                      controller: codigoBarraController,
                      validator: (value) =>
                          value.isEmpty ? "campo obrigário" : null,
                      decoration: InputDecoration(
                        labelText: "use scanner ou digite aquí",
                        hintText: "Digite o código de barra",
                        prefixIcon: Icon(Icons.camera_alt),
                        filled: true,
                        fillColor: Colors.grey[600],
                        hintStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      maxLength: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        label: Text("Scanner"),
        icon: Icon(Icons.camera_enhance),
        onPressed: () {
          barcodeScanning();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  buscarByCodigoDeBarra(String codBarra) async {
    p = await produtoController.getCodigoBarra(codBarra);
    print(p.descricao);
  }

  showToast(String cardTitle) {
    Fluttertoast.showToast(
      msg: "Atenção: $cardTitle",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      fontSize: 16.0,
    );
  }

  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
      // audioPlayer.play("beep-07.mp3");
      // audioCache.play("beep-07.mp3");
      setState(() {
        this.barcode = barcode;
        codigoBarraController.text = this.barcode;
        // buscarByCodigoDeBarra(this.barcode);
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'Permissão negada!';
        });
      } else {
        setState(() => this.barcode = 'Ops! erro: $e');
      }
    } on FormatException {
      setState(() => this.barcode = 'Nada capturado.');
    } catch (e) {
      setState(() => this.barcode = 'Erros: $e');
    }
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
