import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosso/src/paginas/cliente/cliente_create_page.dart';
import 'package:nosso/src/paginas/usuario/usuario_login.dart';

class UsuarioPerfil extends StatefulWidget {
  @override
  _UsuarioPerfilState createState() => _UsuarioPerfilState();
}

class _UsuarioPerfilState extends State<UsuarioPerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("minha conta"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Colors.grey[400],
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
                        Icons.photo_camera,
                        size: 40,
                      ),
                    ),
                  ),
                  SizedBox(height: 0),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(2),
                    height: 30,
                    child: Text(
                      "Fabio Resplandes da Costa",
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(2),
                    height: 30,
                    child: Text(
                      "sobre",
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[300],
                alignment: Alignment.center,
                padding: EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RaisedButton.icon(
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
                      label: Text("criar conta"),
                    ),
                    RaisedButton.icon(
                      icon: Icon(Icons.account_circle_outlined),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return UsuarioLogin();
                            },
                          ),
                        );
                      },
                      label: Text("login agora"),
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
