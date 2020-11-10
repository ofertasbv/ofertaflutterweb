import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masked_text_input_formatter/masked_text_input_formatter.dart';
import 'package:nosso/src/core/controller/cidade_controller.dart';
import 'package:nosso/src/core/controller/endereco_controller.dart';
import 'package:nosso/src/core/controller/estado_controller.dart';
import 'package:nosso/src/core/model/cidade.dart';
import 'package:nosso/src/core/model/endereco.dart';
import 'package:nosso/src/core/model/estado.dart';
import 'package:nosso/src/paginas/endereco/endereco_page.dart';
import 'package:nosso/src/util/dialogs/dialogs.dart';
import 'package:nosso/src/util/load/circular_progresso_mini.dart';

class EnderecoCreatePage extends StatefulWidget {
  Endereco endereco;

  EnderecoCreatePage({Key key, this.endereco}) : super(key: key);

  @override
  _EnderecoCreatePageState createState() =>
      _EnderecoCreatePageState(endereco: endereco);
}

class _EnderecoCreatePageState extends State<EnderecoCreatePage> {
  EnderecoController enderecoController = GetIt.I.get<EnderecoController>();
  EstadoController estadoController = GetIt.I.get<EstadoController>();
  CidadeController cidadeController = GetIt.I.get<CidadeController>();

  Dialogs dialogs = Dialogs();

  Endereco endereco;
  Estado estadoSelecionado;
  Cidade cidadeSelecionada;

  Future<List<Estado>> estados;
  Future<List<Cidade>> cidades;

  File file;
  bool isButtonDesable = false;

  String tipoEndereco;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _EnderecoCreatePageState({this.endereco});

  var controllerNome = TextEditingController();
  var latitudeController = TextEditingController();
  var longitudeController = TextEditingController();

  var controllerDestino = TextEditingController();
  var controllerLogradouro = TextEditingController();
  var controllerNumero = TextEditingController();
  var controllerBairro = TextEditingController();
  var controllerCidade = TextEditingController();
  var controllerCep = TextEditingController();
  var controllerLatitude = TextEditingController();
  var controllerLongitude = TextEditingController();

  @override
  void initState() {
    enderecoController.getAll();
    estados = estadoController.getAll();

    if (endereco == null) {
      endereco = Endereco();
    } else {
      controllerDestino.text = endereco.logradouro;
      controllerNumero.text = endereco.numero;
      controllerCep.text = endereco.cep;
      controllerBairro.text = endereco.bairro;
      controllerLatitude.text = endereco.latitude.toString();
      controllerLongitude.text = endereco.longitude.toString();
    }

    tipoEndereco = "COMERCIAL";
    cidadeSelecionada = endereco.cidade;
    super.initState();
  }

  Controller controller;

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
        indoorViewEnabled: true,
        mapToolbarEnabled: true,
        buildingsEnabled: true,
        tiltGesturesEnabled: true,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        rotateGesturesEnabled: true,
        trafficEnabled: false,
        mapType: MapType.satellite,
        initialCameraPosition: CameraPosition(
          target: LatLng(-4.253467, -49.944051),
          zoom: 16,
        ),
      ),
    );
  }

  chamarEndereco() async {
    String enderecoDestino = controllerDestino.text;

    if (enderecoDestino.isNotEmpty) {
      List<Placemark> listaEnderecos =
          await Geolocator().placemarkFromAddress(enderecoDestino);

      if (listaEnderecos != null && listaEnderecos.length > 0) {
        Placemark e = listaEnderecos[0];
        endereco = Endereco();
        // cidadeSelecionada.nome = e.subAdministrativeArea;
        endereco.cep = e.postalCode;
        endereco.bairro = e.subLocality;
        endereco.logradouro = e.thoroughfare;
        endereco.numero = e.subThoroughfare;

        endereco.latitude = e.position.latitude;
        endereco.longitude = e.position.longitude;

        String enderecoConfirmacao;
        // enderecoConfirmacao = "\n Cidade: " + cidadeSelecionada.nome;
        enderecoConfirmacao =
            "\n Rua: " + endereco.logradouro + ", " + endereco.numero;
        enderecoConfirmacao += "\n Bairro: " + endereco.bairro;
        enderecoConfirmacao += "\n Cep: " + endereco.cep;
        enderecoConfirmacao += "\n Latitude: " + endereco.latitude.toString();
        enderecoConfirmacao += "\n Longitude: " + endereco.longitude.toString();

        showDialog(
          context: context,
          builder: (contex) {
            return AlertDialog(
              title: Text("Confirmação do endereço"),
              content: Text(enderecoConfirmacao),
              contentPadding: EdgeInsets.all(16),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(contex).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    controllerLogradouro.text = endereco.logradouro;
                    controllerNumero.text = endereco.numero;
                    controllerBairro.text = endereco.bairro;
                    // controllerCidade.text = cidadeSelecionada.nome;
                    controllerCep.text = endereco.cep;
                    controllerLatitude.text = endereco.latitude.toString();
                    controllerLongitude.text = endereco.longitude.toString();
                    //p.enderecos.add(e);
                    Navigator.of(contex).pop();
                  },
                )
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastro endereços"),
      ),
      body: Observer(
        builder: (context) {
          if (enderecoController.dioError == null) {
            return buildListViewForm(context);
          } else {
            print("Erro: ${enderecoController.mensagem}");
            showToast("${enderecoController.mensagem}");
            return buildListViewForm(context);
          }
        },
      ),
    );
  }

  buildListViewForm(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                criaMapa(),
                SizedBox(height: 20),
                Card(
                  child: Container(
                    color: Colors.grey[200],
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          controller: controllerDestino,
                          onSaved: (value) => endereco.logradouro = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Pesquisa endereço",
                            hintText: "Rua/Avenida, número",
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            labelStyle: TextStyle(color: Colors.black),
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
                        ),
                        RaisedButton.icon(
                          icon: Icon(Icons.search),
                          label: Text("Pesquisar"),
                          onPressed: () {
                            chamarEndereco();
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
                                groupValue: endereco.tipoEndereco == null
                                    ? tipoEndereco
                                    : endereco.tipoEndereco,
                                onChanged: (String valor) {
                                  setState(() {
                                    endereco.tipoEndereco = valor;
                                    print(
                                        "resultado: " + endereco.tipoEndereco);
                                  });
                                },
                              ),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text("RESIDENCIAL"),
                                value: "RESIDENCIAL",
                                groupValue: endereco.tipoEndereco == null
                                    ? tipoEndereco
                                    : endereco.tipoEndereco,
                                onChanged: (String valor) {
                                  setState(() {
                                    endereco.tipoEndereco = valor;
                                    print(
                                        "resultado: " + endereco.tipoEndereco);
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
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          controller: controllerLogradouro,
                          onSaved: (value) => endereco.complemento = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Complemento",
                            hintText: "Complemento",
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                            labelStyle: TextStyle(color: Colors.black),
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
                        ),
                        TextFormField(
                          controller: controllerNumero,
                          onSaved: (value) => endereco.numero = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Número",
                            hintText: "Número",
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                            labelStyle: TextStyle(color: Colors.black),
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
                        ),
                        TextFormField(
                          controller: controllerCep,
                          onSaved: (value) => endereco.cep = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Cep",
                            hintText: "Cep",
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lime[900]),
                              gapPadding: 1,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            MaskedTextInputFormatter(
                                mask: '99999-999', separator: '-')
                          ],
                          maxLength: 9,
                        ),
                        TextFormField(
                          controller: controllerBairro,
                          onSaved: (value) => endereco.bairro = value,
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Bairro",
                            hintText: "Bairro",
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            labelStyle: TextStyle(color: Colors.black),
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
                        ),
                        TextFormField(
                          controller: controllerLatitude,
                          onSaved: (value) =>
                              endereco.latitude = double.tryParse(value),
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Latitude",
                            hintText: "Latidute",
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lime[900]),
                              gapPadding: 1,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(),
                          maxLength: 50,
                        ),
                        TextFormField(
                          controller: controllerLongitude,
                          onSaved: (value) =>
                              endereco.longitude = double.tryParse(value),
                          validator: (value) =>
                              value.isEmpty ? "campo obrigário" : null,
                          decoration: InputDecoration(
                            labelText: "Longitude",
                            hintText: "Longitude",
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lime[900]),
                              gapPadding: 1,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
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
            padding: EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                title: Text("Estado *"),
                subtitle: estadoSelecionado == null
                    ? Text("Selecione uma estado")
                    : Text(estadoSelecionado.nome),
                leading: Icon(Icons.list_alt_outlined),
                trailing: Icon(Icons.arrow_drop_down_sharp),
                onTap: () {
                  alertSelectEstados(context, estadoSelecionado);
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
                  borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                title: Text("Cidade *"),
                subtitle: cidadeSelecionada == null
                    ? Text("Selecione uma cidade")
                    : Text(cidadeSelecionada.nome),
                leading: Icon(Icons.list_alt_outlined),
                trailing: Icon(Icons.arrow_drop_down_sharp),
                onTap: () {
                  alertSelectCidades(context, cidadeSelecionada);
                },
              ),
            ),
          ),
        ),
        Card(
          child: RaisedButton.icon(
            label: Text("Enviar formulário"),
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              if (controller.validate()) {
                if (endereco.id == null) {
                  dialogs.information(context, "prepando para o cadastro...");
                  Timer(Duration(seconds: 3), () {
                    endereco.cidade = cidadeSelecionada;
                    enderecoController.create(endereco);
                    Navigator.of(context).pop();
                    buildPush(context);
                  });
                } else {
                  dialogs.information(
                      context, "preparando para o alteração...");
                  Timer(Duration(seconds: 1), () {
                    endereco.cidade = cidadeSelecionada;
                    enderecoController.update(endereco.id, endereco);
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
        builder: (context) => EnderecoPage(),
      ),
    );
  }

  /* ============== ESTADO LISTA ============== */

  alertSelectEstados(BuildContext context, Estado c) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: builderConteudoListEstados(),
          ),
        );
      },
    );
  }

  builderConteudoListEstados() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Estado> estados = estadoController.estados;
          if (cidadeController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (estados == null) {
            return CircularProgressorMini();
          }

          return builderListEstados(estados);
        },
      ),
    );
  }

  builderListEstados(List<Estado> estados) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.builder(
      itemCount: estados.length,
      itemBuilder: (context, index) {
        Estado c = estados[index];

        return Column(
          children: [
            GestureDetector(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.location_on_outlined),
                ),
                title: Text(c.nome),
              ),
              onTap: () {
                setState(() {
                  estadoSelecionado = c;
                  cidadeController.getAllByEstadoId(estadoSelecionado.id);
                  print("${estadoSelecionado.nome}");
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

  /* ============== CIDADE LISTA ============== */

  alertSelectCidades(BuildContext context, Cidade c) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: builderConteudoListCidades(),
          ),
        );
      },
    );
  }

  builderConteudoListCidades() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Cidade> cidades = cidadeController.cidades;
          if (cidadeController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (cidades == null) {
            return CircularProgressorMini();
          }

          return builderListCidades(cidades);
        },
      ),
    );
  }

  builderListCidades(List<Cidade> cidades) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.builder(
      itemCount: cidades.length,
      itemBuilder: (context, index) {
        Cidade c = cidades[index];

        return Column(
          children: [
            GestureDetector(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.location_on_outlined),
                ),
                title: Text(c.nome),
              ),
              onTap: () {
                setState(() {
                  cidadeSelecionada = c;
                  print("${cidadeSelecionada.nome}");
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
