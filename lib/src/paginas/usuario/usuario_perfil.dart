import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/usuario_controller.dart';
import 'package:nosso/src/core/model/usuario.dart';
import 'package:nosso/src/paginas/endereco/endereco_cliente_page.dart';
import 'package:nosso/src/paginas/endereco/endereco_loja_page.dart';
import 'package:nosso/src/paginas/usuario/usuario_create_page.dart';
import 'package:nosso/src/paginas/usuario/usuario_edit_page.dart';

class UsuarioPerfil extends StatefulWidget {
  @override
  _UsuarioPerfilState createState() => _UsuarioPerfilState();
}

class _UsuarioPerfilState extends State<UsuarioPerfil> {
  var usuarioController = GetIt.I.get<UsuarioController>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 150,
          color: Theme.of(context).accentColor.withOpacity(0.1),
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
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(height: 0),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(2),
                height: 30,
                child: Observer(
                  builder: (context) {
                    Usuario u = usuarioController.usuarioSelecionado;
                    if (u == null) {
                      return Text("Minha conta");
                    }
                    return Text(
                      "${u.email}",
                      style: TextStyle(
                        color: Colors.grey[900],
                      ),
                    );
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(2),
                height: 30,
                child: Observer(
                  builder: (context) {
                    Usuario u = usuarioController.usuarioSelecionado;
                    if (u == null) {
                      return Text("Minha conta");
                    }
                    return Text(
                      "${u.pessoa.nome}",
                      style: TextStyle(
                        color: Colors.grey[900],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 570,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                title: Text("Cupom de desconto"),
                subtitle: Text("Resgate seu cupom de desconto"),
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
                title: Text("Minha lista de desejo"),
                subtitle: Text("Todos os seus desejos"),
                leading: CircleAvatar(
                  child: Icon(Icons.list_alt_outlined),
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
                title: Text("Dados pesoais"),
                subtitle: Text("Alterar senha, login, email, e dados pessoais"),
                leading: CircleAvatar(
                  child: Icon(Icons.account_circle_outlined),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return UsuarioEditPage();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Minhas avaliações"),
                subtitle: Text("Suas opiniões dos produtos de desejo"),
                leading: CircleAvatar(
                  child: Icon(Icons.star_border),
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
                title: Text("Endereço de cliente"),
                subtitle: Text("Altere seu endereço"),
                leading: CircleAvatar(
                  child: Icon(Icons.location_on_outlined),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return EnderecoClientePage();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Endereço de loja"),
                subtitle: Text("Altere seu endereço"),
                leading: CircleAvatar(
                  child: Icon(Icons.location_on_outlined),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return EnderecoLojaPage();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Atedimento ao cliente"),
                subtitle: Text("Envie um e-mail"),
                leading: CircleAvatar(
                  child: Icon(Icons.email_outlined),
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
                title: Text("Sair"),
                subtitle: Text("Acesse com outra conta"),
                leading: CircleAvatar(
                  child: Icon(Icons.logout),
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
            ],
          ),
        ),
      ],
    );
  }
}
