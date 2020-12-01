import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/usuario_controller.dart';
import 'package:nosso/src/core/model/usuario.dart';
import 'package:nosso/src/paginas/usuario/usuario_login.dart';
import 'package:nosso/src/paginas/usuario/usuario_perfil.dart';

class UsuarioPerfilPage extends StatefulWidget {
  @override
  _UsuarioPerfilPageState createState() => _UsuarioPerfilPageState();
}

class _UsuarioPerfilPageState extends State<UsuarioPerfilPage> {
  var usuarioController = GetIt.I.get<UsuarioController>();
  @override
  Widget build(BuildContext context) {
    return usuarioHome();
  }

  usuarioHome() {
    return Observer(
      builder: (context) {
        Usuario u = usuarioController.usuarioSelecionado;
        if (u != null) {
          return UsuarioPerfil();
        }
        return UsuarioLogin();
      },
    );
  }
}
