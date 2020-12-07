import 'package:flutter/material.dart';
import 'package:nosso/src/core/controller/loja_controller.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/paginas/loja/loja_create_page.dart';
import 'package:nosso/src/paginas/loja/loja_detalhes_tab.dart';

class ContainerLoja extends StatelessWidget {
  LojaController lojaController;
  Loja p;

  ContainerLoja(this.lojaController, this.p);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey[200], width: 1),
      ),
      child: AnimatedContainer(
        width: 350,
        height: 150,
        duration: Duration(seconds: 1),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[100].withOpacity(0.1),
              Colors.grey[100].withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      lojaController.arquivo + p.foto,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 150,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: ListTile(
                        title: Text("${p.nome}"),
                        subtitle: Text("Código. ${p.id}"),
                        trailing: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.redAccent,
                          child: IconButton(
                            splashColor: Colors.black,
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.redAccent,
                              size: 15,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        title: Text(" ${p.razaoSocial}"),
                        subtitle: Text("${p.telefone}"),
                        trailing: buildPopupMenuButton(context, p),
                      ),
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

  PopupMenuButton<String> buildPopupMenuButton(BuildContext context, Loja p) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert),
      onSelected: (valor) {
        if (valor == "novo") {
          print("novo");
        }

        if (valor == "editar") {
          print("editar");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return LojaCreatePage(
                  loja: p,
                );
              },
            ),
          );
        }

        if (valor == "detalhes") {
          print("detalhes");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return LojaDetalhesTab(p);
              },
            ),
          );
        }

        if (valor == "delete") {
          print("delete");
        }

        if (valor == "local") {
          print("local");
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'novo',
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('novo'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'editar',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('editar'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'detalhes',
          child: ListTile(
            leading: Icon(Icons.search),
            title: Text('detalhes'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('delete'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'local',
          child: ListTile(
            leading: Icon(Icons.location_on),
            title: Text('local'),
          ),
        )
      ],
    );
  }
}
