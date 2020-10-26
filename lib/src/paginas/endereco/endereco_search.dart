import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/endereco_controller.dart';
import 'package:nosso/src/core/model/endereco.dart';
import 'package:nosso/src/core/model/produto.dart';
import 'package:nosso/src/paginas/loja/loja_create_page.dart';
import 'package:nosso/src/util/load/circular_progresso.dart';

class EnderecoSearchDelegate extends SearchDelegate<Produto> {
  EnderecoController enderecoController = GetIt.I.get<EnderecoController>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
      autofocus: true,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    enderecoController.getAll();
    return Observer(
      builder: (context) {
        List<Endereco> enderecos = enderecoController.enderecos;

        if (enderecoController.error != null) {
          return Text("Não foi possível buscar endereços");
        }

        if (enderecoController == null) {
          return CircularProgressor();
        }

        final resultados = query.isEmpty
            ? []
            : enderecos
                .where((p) =>
                    p.logradouro.toLowerCase().startsWith(query.toLowerCase()))
                .toList();

        if (resultados.length == 0) {
          return Center(
            child: Text("pesquisar endereço"),
          );
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            Endereco e = resultados[index];
            return ListTile(
              leading: CircleAvatar(
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(100.0),
                  child: Image.asset(ConstantApi.urlNormal),
                ),
              ),
              title: RichText(
                text: TextSpan(
                    text: e.logradouro.substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: e.logradouro.substring(query.length) +
                              ", " +
                              e.numero,
                          style: TextStyle(color: Colors.grey))
                    ]),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return LojaCreatePage();
                    },
                  ),
                );
              },
            );
          },
          itemCount: resultados.length,
        );
      },
    );
  }
}
