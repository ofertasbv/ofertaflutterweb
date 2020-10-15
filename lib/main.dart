
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/arquivo_controller.dart';
import 'package:nosso/src/core/controller/categoria_controller.dart';
import 'package:nosso/src/core/controller/cidade_controller.dart';
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
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/services.dart';
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
  getIt.registerSingleton<CidadeController>(CidadeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildThemeDataBlue(context),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      home: HomePage(),
    );
  }

  buildThemeDataBlue(BuildContext context) {
    return ThemeData(
      backgroundColor: Theme.of(context).bottomAppBarColor,
      brightness: Brightness.light,
      primaryColor: Colors.amber,
      accentColor: Colors.indigo[900],
      primarySwatch: Colors.amber,

      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.indigo[900],
            displayColor: Colors.amber,
          ),

      dialogTheme: DialogTheme(
        backgroundColor: Colors.grey[100],
        elevation: 2,
        titleTextStyle: TextStyle(color: Colors.indigo[900]),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10),
          side: BorderSide(color: Colors.white),
        ),
      ),

      primaryTextTheme: TextTheme(
        headline6: TextStyle(color: Colors.indigo[900]),
      ),

      primaryIconTheme: IconThemeData(color: Colors.indigo[900]),

      // fontFamily: 'Georgia',
      dialogBackgroundColor: Colors.grey[100],

      cardTheme: CardTheme(
        elevation: 1,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(0.0),
          side: BorderSide(color: Colors.white),
        ),
      ),

      hintColor: Colors.amber,

      buttonTheme: ButtonThemeData(
        buttonColor: Colors.amber,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(0.0),
          side: BorderSide(color: Colors.transparent),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        prefixStyle: TextStyle(color: Colors.amber),
        hintStyle: TextStyle(color: Colors.indigo[900]),
        fillColor: Colors.amber,
      ),

      iconTheme: IconThemeData(
        color: Colors.amber,
      ),
      snackBarTheme: SnackBarThemeData(
        actionTextColor: Colors.indigo[900],
        backgroundColor: Colors.amber,
      ),
      scaffoldBackgroundColor: Colors.white,
      bottomSheetTheme: BottomSheetThemeData(
        modalElevation: 0,
        backgroundColor: Colors.amber,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.indigo[900],
        unselectedLabelStyle: TextStyle(color: Colors.amber),
        backgroundColor: Colors.grey[100],
      ),
    );
  }
}

