import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosso/src/paginas/usuario/usuario_perfil.dart';

class UsuarioPerfilPage extends StatefulWidget {
  @override
  _UsuarioPerfilPageState createState() => _UsuarioPerfilPageState();
}

class _UsuarioPerfilPageState extends State<UsuarioPerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("minha conta"),
      ),
      body: UsuarioPerfil(),
    );
  }
}
