import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masked_text_input_formatter/masked_text_input_formatter.dart';
import 'package:nosso/src/core/controller/cidade_controller.dart';
import 'package:nosso/src/core/controller/endereco_controller.dart';
import 'package:nosso/src/core/model/cidade.dart';
import 'package:nosso/src/core/model/endereco.dart';
import 'package:nosso/src/paginas/endereco/endereco_page.dart';

class EnderecoCreatePage extends StatefulWidget {
  Endereco endereco;

  EnderecoCreatePage({Key key, this.endereco}) : super(key: key);

  @override
  _EnderecoCreatePageState createState() =>
      _EnderecoCreatePageState(endereco: endereco);
}

class _EnderecoCreatePageState extends State<EnderecoCreatePage> {
  EnderecoController enderecoController = GetIt.I.get<EnderecoController>();

  CidadeController cidadeController = GetIt.I.get<CidadeController>();

  Endereco endereco;
  Cidade cidadeSelecionada;

  Future<List<Cidade>> cidades;

  File file;
  bool isButtonDesable = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _EnderecoCreatePageState({this.endereco});

  var controllerNome = TextEditingController();
  var latitudeController = TextEditingController();
  var longitudeController = TextEditingController();

  @override
  void initState() {
    enderecoController.getAll();
    cidades = cidadeController.getAll();

    if (endereco == null) {
      endereco = Endereco();
    }
    super.initState();
  }

  Controller controller;

  @override
  didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  showDefaultSnackbar(BuildContext context, String content) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.pink[900],
        content: Text(content),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
        ),
      ),
    );
  }

  void showToast(String cardTitle) {
    Fluttertoast.showToast(
      msg: "$cardTitle",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.indigo,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
              title: Text("Photos"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text("Camera"),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  criaMapa() {
    return Container(
      height: 600,
      child: GoogleMap(
        onTap: (valor) {
          print("Lat: ${valor.latitude}, Long: ${valor.longitude}");
          setState(() {
            valor != null
                ? latitudeController.text = valor.latitude.toString()
                : latitudeController.text = endereco.latitude.toString();
            valor != null
                ? longitudeController.text = valor.longitude.toString()
                : longitudeController.text = endereco.longitude.toString();
          });
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        rotateGesturesEnabled: true,
        mapType: MapType.satellite,
        initialCameraPosition: CameraPosition(
          target: LatLng(-4.253467, -49.944051),
          zoom: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro endereços"),
      ),
      body: buildObserver(),
    );
  }

  buildObserver() {
    endereco.cidade = cidadeSelecionada;

    return Observer(
      builder: (context) {
        if (enderecoController.error != null) {
          return Text("Não foi possível cadastrar endereço");
        } else {
          return ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(2),
                child: Form(
                  key: controller.formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      criaMapa(),
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RadioListTile(
                                    controlAffinity:
                                    ListTileControlAffinity.trailing,
                                    title: Text("COMERCIAL"),
                                    value: "COMERCIAL",
                                    groupValue: endereco.tipoEndereco,
                                    onChanged: (String valor) {
                                      setState(() {
                                        endereco.tipoEndereco = valor;
                                        print("resultado: " + endereco.tipoEndereco);
                                        showDefaultSnackbar(context,
                                            "Endereço: ${endereco.tipoEndereco}");
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    controlAffinity:
                                    ListTileControlAffinity.trailing,
                                    title: Text("RESIDENCIAL"),
                                    value: "RESIDENCIAL",
                                    groupValue: endereco.tipoEndereco,
                                    onChanged: (String valor) {
                                      setState(() {
                                        endereco.tipoEndereco = valor;
                                        print("resultado: " + endereco.tipoEndereco);
                                        showDefaultSnackbar(context,
                                            "Endereço: ${endereco.tipoEndereco}");
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
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                initialValue: endereco.logradouro,
                                onSaved: (value) => endereco.logradouro = value,
                                validator: (value) =>
                                    value.isEmpty ? "campo obrigário" : null,
                                decoration: InputDecoration(
                                  labelText: "Logradouro",
                                  hintText: "Logradouro",
                                  prefixIcon: Icon(Icons.location_on),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 20.0, 20.0, 20.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                                keyboardType: TextInputType.text,
                                maxLength: 50,
                              ),
                              TextFormField(
                                initialValue: endereco.numero,
                                onSaved: (value) => endereco.numero = value,
                                validator: (value) =>
                                    value.isEmpty ? "campo obrigário" : null,
                                decoration: InputDecoration(
                                  labelText: "Número",
                                  hintText: "Número",
                                  prefixIcon: Icon(Icons.location_on),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 20.0, 20.0, 20.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                              ),
                              TextFormField(
                                initialValue: endereco.cep,
                                onSaved: (value) => endereco.cep = value,
                                validator: (value) =>
                                    value.isEmpty ? "campo obrigário" : null,
                                decoration: InputDecoration(
                                  labelText: "Cep",
                                  hintText: "Cep",
                                  prefixIcon: Icon(Icons.location_on),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 20.0, 20.0, 20.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  MaskedTextInputFormatter(
                                      mask: '99999-999', separator: '-')
                                ],
                                maxLength: 9,
                              ),
                              TextFormField(
                                initialValue: endereco.bairro,
                                onSaved: (value) => endereco.bairro = value,
                                validator: (value) =>
                                    value.isEmpty ? "campo obrigário" : null,
                                decoration: InputDecoration(
                                  labelText: "Bairro",
                                  hintText: "Bairro",
                                  prefixIcon: Icon(Icons.location_on),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 20.0, 20.0, 20.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                                keyboardType: TextInputType.text,
                                maxLength: 50,
                              ),
                              TextFormField(
                                controller: latitudeController,
                                // initialValue: endereco.latitude,
                                onSaved: (value) => endereco.latitude = double.tryParse(value),
                                validator: (value) =>
                                    value.isEmpty ? "campo obrigário" : null,
                                decoration: InputDecoration(
                                  labelText: "Latitude",
                                  hintText: "Latidute",
                                  prefixIcon: Icon(Icons.location_on),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 20.0, 20.0, 20.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                                keyboardType: TextInputType.numberWithOptions(),
                                maxLength: 50,
                              ),
                              TextFormField(
                                controller: longitudeController,
                                // initialValue: endereco.longitude,
                                onSaved: (value) => endereco.longitude = double.tryParse(value),
                                validator: (value) =>
                                    value.isEmpty ? "campo obrigário" : null,
                                decoration: InputDecoration(
                                  labelText: "Longitude",
                                  hintText: "Longitude",
                                  prefixIcon: Icon(Icons.location_on),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 20.0, 20.0, 20.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                                keyboardType: TextInputType.numberWithOptions(),
                                maxLength: 50,
                              ),
                            ],
                          ),
                        ),
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
                      FutureBuilder<List<Cidade>>(
                        future: cidades,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormField<Cidade>(
                              validator: (value) =>
                                  value == null ? 'selecione uma cidade' : null,
                              value: cidadeSelecionada,
                              items: snapshot.data.map((cidade) {
                                return DropdownMenuItem<Cidade>(
                                  value: cidade,
                                  child: Text(cidade.nome),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              hint: Text("Selecione cidade..."),
                              onChanged: (Cidade c) {
                                setState(() {
                                  cidadeSelecionada = c;
                                  print(cidadeSelecionada.nome);
                                });
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          return Text("não foi peossível carregar cidades");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  label: Text(
                    "Enviar formulário",
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
                      enderecoController.create(endereco);
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnderecoPage(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        }
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
