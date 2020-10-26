import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nosso/src/core/controller/arquivo_controller.dart';
import 'package:nosso/src/core/controller/categoria_controller.dart';
import 'package:nosso/src/core/controller/cidade_controller.dart';
import 'package:nosso/src/core/controller/cliente_controller.dart';
import 'package:nosso/src/core/controller/endereco_controller.dart';
import 'package:nosso/src/core/controller/estado_controller.dart';
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
  getIt.registerSingleton<EstadoController>(EstadoController());
  getIt.registerSingleton<CidadeController>(CidadeController());

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // cor da barra superior
      statusBarIconBrightness: Brightness.dark,
      // ícones da barra superior
      systemNavigationBarColor: Colors.grey[100],
      // cor da barra inferior
      systemNavigationBarIconBrightness: Brightness.dark,
      //
      systemNavigationBarDividerColor: Colors.black, // ícones da barra inferior

      statusBarBrightness: Brightness.dark,
    ),
  );

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
      brightness: Brightness.light,
      primaryColor: Colors.grey[100],
      accentColor: Colors.orangeAccent,
      primarySwatch: Colors.orange,

      appBarTheme: AppBarTheme(
        elevation: 0,
      ),

      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.black,
            displayColor: Colors.orangeAccent,
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
        headline6: TextStyle(color: Colors.orangeAccent),
        headline5: TextStyle(color: Colors.blueAccent),
        headline4: TextStyle(color: Colors.black),
        headline3: TextStyle(color: Colors.pink),
        headline2: TextStyle(color: Colors.green),
        headline1: TextStyle(color: Colors.cyan),
      ),

      primaryIconTheme: IconThemeData(color: Colors.orangeAccent),

      // fontFamily: 'Georgia',
      dialogBackgroundColor: Colors.grey[100],

      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.white,
        clipBehavior: Clip.none,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5),
          side: BorderSide(color: Colors.transparent),
        ),
      ),

      buttonTheme: ButtonThemeData(
        splashColor: Colors.black,
        textTheme: ButtonTextTheme.primary,
        height: 50,
        padding: EdgeInsets.all(10),
        alignedDropdown: true,
        buttonColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30),
          side: BorderSide(color: Colors.transparent),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        prefixStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.black),
        fillColor: Colors.orangeAccent,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo),
          gapPadding: 1,
          borderRadius: BorderRadius.circular(5.0),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),

      hintColor: Colors.grey,

      iconTheme: IconThemeData(
        color: Colors.orangeAccent,
      ),
      snackBarTheme: SnackBarThemeData(
        actionTextColor: Colors.indigo[900],
        backgroundColor: Colors.amber,
      ),

      scaffoldBackgroundColor: Colors.white,

      bottomSheetTheme: BottomSheetThemeData(
        modalElevation: 0,
        backgroundColor: Colors.orangeAccent,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(color: Colors.orangeAccent),
        backgroundColor: Colors.white,
      ),
    );
  }
}
