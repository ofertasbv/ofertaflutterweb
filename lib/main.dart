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
import 'package:nosso/src/util/Examples/buttons.dart';

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

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.amber,
      // cor da barra superior
      statusBarIconBrightness: Brightness.light,
      // ícones da barra superior
      systemNavigationBarColor: Colors.amber,
      // cor da barra inferior
      systemNavigationBarIconBrightness: Brightness.light,
      //
      systemNavigationBarDividerColor: Colors.black, // ícones da barra inferior
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
      primaryColor: Colors.white,
      accentColor: Colors.black,
      primarySwatch: Colors.amber,

      appBarTheme: AppBarTheme(
        elevation: 2,
      ),

      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.black,
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
        headline6: TextStyle(color: Colors.black),
        headline5: TextStyle(color: Colors.blueAccent),
        headline4: TextStyle(color: Colors.black),
        headline3: TextStyle(color: Colors.pink),
      ),

      primaryIconTheme: IconThemeData(color: Colors.black),

      // fontFamily: 'Georgia',
      dialogBackgroundColor: Colors.grey[100],

      cardTheme: CardTheme(
        elevation: 1,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(0.0),
          side: BorderSide(color: Colors.grey[100]),
        ),
      ),

      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(32),
          side: BorderSide(color: Colors.black),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        prefixStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.black),
        fillColor: Colors.amber,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        border: OutlineInputBorder(
          gapPadding: 1,
          borderRadius: BorderRadius.circular(5.0),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),

      hintColor: Colors.amber,

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
        elevation: 0,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(color: Colors.amber),
        backgroundColor: Colors.grey[100],
      ),
    );
  }
}
