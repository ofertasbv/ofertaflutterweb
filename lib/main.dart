import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/arquivo_controller.dart';
import 'package:nosso/src/core/controller/categoria_controller.dart';
import 'package:nosso/src/core/controller/cliente_controller.dart';
import 'package:nosso/src/core/controller/endereco_controller.dart';
import 'package:nosso/src/core/controller/loja_controller.dart';
import 'package:nosso/src/core/controller/marca_controller.dart';
import 'package:nosso/src/core/controller/pedidoItem_controller.dart';
import 'package:nosso/src/core/controller/pedido_controller.dart';
import 'package:nosso/src/core/controller/permissao_controller.dart';
import 'package:nosso/src/core/controller/promocao_controller.dart';
import 'package:nosso/src/core/controller/subcategoria_controller.dart';
import 'package:nosso/src/core/controller/produto_controller.dart';
import 'package:nosso/src/home/home.dart';

void main() async {
  GetIt getIt = GetIt.I;
  getIt.registerSingleton<ArquivoController>(ArquivoController());
  getIt.registerSingleton<CategoriaController>(CategoriaController());
  getIt.registerSingleton<SubCategoriaController>(SubCategoriaController());
  getIt.registerSingleton<PromoCaoController>(PromoCaoController());
  getIt.registerSingleton<ProdutoController>(ProdutoController());
  getIt.registerSingleton<EnderecoController>(EnderecoController());
  getIt.registerSingleton<PedidoController>(PedidoController());
  getIt.registerSingleton<PedidoItemController>(PedidoItemController());

  getIt.registerSingleton<PermissaoController>(PermissaoController());
  getIt.registerSingleton<ClienteController>(ClienteController());
  getIt.registerSingleton<LojaController>(LojaController());
  getIt.registerSingleton<MarcaController>(MarcaController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildThemeDataBlack(),
      home: HomePage(),
    );
  }

  ThemeData buildThemeDataBlack() {
    return ThemeData(
      primarySwatch: Colors.orange,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.black,
      accentColor: Colors.purple,
    );
  }

  ThemeData buildThemeDataYellow() {
    return ThemeData(
      primarySwatch: Colors.orange,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.yellow,
      accentColor: Colors.purple,
    );
  }
}
