import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/usuario_controller.dart';
import 'package:nosso/src/core/model/usuario.dart';
import 'package:nosso/src/paginas/cliente/cliente_create_page.dart';
import 'package:nosso/src/paginas/usuario/usuario_create_page.dart';
import 'package:nosso/src/paginas/usuario/usuario_recuperar_senha.dart';

class UsuarioEditPage extends StatefulWidget {
  @override
  _UsuarioEditPageState createState() => _UsuarioEditPageState();
}

class _UsuarioEditPageState extends State<UsuarioEditPage> {
  var usuarioController = GetIt.I.get<UsuarioController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil de usuário"),
      ),
      body: ListView(
        children: [
          Container(
            height: 240,
            color: Colors.grey[100],
            alignment: Alignment.center,
            padding: EdgeInsets.all(2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: Text("Alterar login"),
                  subtitle: Text("Altere seu login"),
                  leading: CircleAvatar(
                    child: Icon(Icons.games_outlined),
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
                ),
                ListTile(
                  title: Text("Alterar senha"),
                  subtitle: Text("Atualize sua senha"),
                  leading: CircleAvatar(
                    child: Icon(Icons.list_alt_outlined),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return UsuarioRecuperarSenha();
                        },
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text("Alterar dados pessoais"),
                  subtitle:
                      Text("Nome, CPF, RG"),
                  leading: CircleAvatar(
                    child: Icon(Icons.account_circle_outlined),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ClienteCreatePage();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
