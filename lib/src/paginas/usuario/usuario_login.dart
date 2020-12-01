import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/usuario_controller.dart';
import 'package:nosso/src/core/model/usuario.dart';
import 'package:nosso/src/home/home.dart';
import 'package:nosso/src/paginas/cliente/cliente_create_page.dart';
import 'package:nosso/src/paginas/usuario/usuario_create_page.dart';
import 'package:nosso/src/util/dialogs/dialogs.dart';

class UsuarioLogin extends StatefulWidget {
  @override
  _UsuarioLoginState createState() => _UsuarioLoginState();
}

class _UsuarioLoginState extends State<UsuarioLogin> {
  var usuarioController = GetIt.I.get<UsuarioController>();
  Dialogs dialogs = Dialogs();

  Usuario u;
  bool isButtonDesable = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    usuarioController.getAll();
    if (u == null) {
      u = Usuario();
    }
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

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (usuarioController.dioError == null) {
          return buildListViewForm(context);
        } else {
          print("Erro: ${usuarioController.mensagem}");
          showToast("${usuarioController.mensagem}");
          return buildListViewForm(context);
        }
      },
    );
  }

  buildListViewForm(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          height: 150,
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(1),
                decoration: new BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.grey[900]],
                  ),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  radius: 40,
                  child: Icon(
                    Icons.person,
                    size: 40,
                  ),
                ),
              ),
              SizedBox(height: 0),
            ],
          ),
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
                        initialValue: u.email,
                        onSaved: (value) => u.email = value,
                        validator: (value) =>
                            value.isEmpty ? "campo obrigário" : null,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "email@gmail.com",
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                          ),
                          suffixIcon: Icon(Icons.close),
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lime[900]),
                            gapPadding: 1,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 50,
                        maxLines: 1,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: u.senha,
                        onSaved: (value) => u.senha = value,
                        validator: (value) =>
                            value.isEmpty ? "campo obrigário" : null,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          hintText: "Senha",
                          prefixIcon: Icon(Icons.security, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.visibility, color: Colors.grey),
                            onPressed: () {
                              usuarioController.visualizarSenha();
                            },
                          ),
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
                        obscureText: !usuarioController.senhaVisivel,
                        maxLength: 8,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(10),
          child: RaisedButton.icon(
            label: Text("confirmar login"),
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              if (controller.validate()) {
                if (u.id == null) {
                  dialogs.information(context, "verificando login...");
                  Timer(Duration(seconds: 3), () {
                    usuarioController.getLogin(u.email, u.senha);
                    Navigator.pop(context);
                    buildPush(context);
                  });
                }
              }
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: RaisedButton.icon(
            color: Colors.grey[300],
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ClienteCreatePage();
                  },
                ),
              );
            },
            label: Text("Não tem conta? cadastre-se"),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Esqueceu a senha ? "),
              GestureDetector(
                child: Text(
                  "Alterar senha",
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return UsuarioCreatePage();
                      },
                    ),
                  );
                },
              )
            ],
          ),
        )
      ],
    );
  }

  buildPush(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
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