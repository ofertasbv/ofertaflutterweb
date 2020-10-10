import 'package:flutter/cupertino.dart';
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
import 'package:flutter_localizations/flutter_localizations.dart';

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
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Colors.amber,
      accentColor: Colors.indigo[900],

      // fontFamily: 'Georgia',
      dialogBackgroundColor: Colors.grey[100],
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 1,
      ),

      hintColor: Colors.amber,

      buttonTheme: ButtonThemeData(
        buttonColor: Colors.amber,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(0.0),
          side: BorderSide(color: Colors.white),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        prefixStyle: TextStyle(color: Colors.amber),
        hintStyle: TextStyle(color: Colors.indigo[900]),
        fillColor: Colors.amber,
      ),

      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 50.0, fontWeight: FontWeight.w600, color: Colors.green),
        headline6: TextStyle(
            fontSize: 22.0,
            fontStyle: FontStyle.normal,
            color: Colors.indigo[900]),
        bodyText2: TextStyle(
            fontSize: 14.0, fontFamily: 'Hind', color: Colors.indigo[900]),
      ),
      iconTheme: IconThemeData(
        color: Colors.amber,
      ),
      snackBarTheme: SnackBarThemeData(
        actionTextColor: Colors.indigo[900],
        backgroundColor: Colors.amber,
      ),
      scaffoldBackgroundColor: Colors.grey[100],
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
