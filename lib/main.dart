import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      statusBarIconBrightness: Brightness.light,
      // ícones da barra superior
      systemNavigationBarColor: Colors.grey[200].withOpacity(0.8),
      // cor da barra inferior
      systemNavigationBarIconBrightness: Brightness.light,
      //
      systemNavigationBarDividerColor: Colors.white,
      // ícones da barra inferior

      statusBarBrightness: Brightness.light,
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
      primarySwatch: Colors.orange,

      appBarTheme: AppBarTheme(
        elevation: 1,
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.orange[900],
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          headline5: TextStyle(color: Colors.blueAccent),
          headline4: TextStyle(color: Colors.yellow),
          headline3: TextStyle(color: Colors.pink),
          headline2: TextStyle(color: Colors.green),
          headline1: TextStyle(color: Colors.cyan),
        ),
      ),

      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: "Cabin",
            bodyColor: Colors.black,
            displayColor: Colors.grey[600],
          ),

      dialogTheme: DialogTheme(
        backgroundColor: Colors.grey[100],
        elevation: 2,
        titleTextStyle: TextStyle(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10),
          side: BorderSide(color: Colors.white),
        ),
      ),

      primaryIconTheme: IconThemeData(color: Colors.orange[900]),

      // fontFamily: 'Georgia',
      dialogBackgroundColor: Colors.grey[100],

      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.grey[100],
        margin: EdgeInsets.all(6),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(2),
          side: BorderSide(color: Colors.grey[200]),
        ),
      ),

      buttonTheme: ButtonThemeData(
        splashColor: Colors.black,
        textTheme: ButtonTextTheme.primary,
        height: 50,
        padding: EdgeInsets.all(10),
        alignedDropdown: true,
        buttonColor: Colors.orange[900],
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30),
          side: BorderSide(color: Colors.white),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        prefixStyle: TextStyle(color: Colors.orange[900]),
        hintStyle: TextStyle(color: Colors.black),
        fillColor: Colors.grey[100],
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          gapPadding: 1,
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusColor: Colors.orange[900],
        hoverColor: Colors.purple,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        suffixStyle: TextStyle(color: Colors.green),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange[900]),
          gapPadding: 1,
          borderRadius: BorderRadius.circular(5.0),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),

      hintColor: Colors.orange[900],

      iconTheme: IconThemeData(
        color: Colors.orange[900],
      ),

      snackBarTheme: SnackBarThemeData(
        actionTextColor: Colors.grey,
        backgroundColor: Colors.orange[900],
      ),

      scaffoldBackgroundColor: Colors.grey[200],

      bottomSheetTheme: BottomSheetThemeData(
        modalElevation: 1,
        backgroundColor: Colors.orange[900],
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 1,
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(color: Colors.orange[900]),
        backgroundColor: Colors.white,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(new MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter Demo',
//       theme: new ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: new MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   bool _loading = false;
//
//   void _onLoading() {
//     setState(() {
//       _loading = true;
//       new Future.delayed(new Duration(seconds: 3), _login);
//     });
//   }
//
//   Future _login() async {
//     setState(() {
//       _loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var body = new Column(
//       children: <Widget>[
//         new Container(
//           height: 40.0,
//           padding: const EdgeInsets.all(10.0),
//           margin: const EdgeInsets.fromLTRB(15.0, 150.0, 15.0, 0.0),
//           decoration: new BoxDecoration(
//             color: Colors.white,
//           ),
//           child: new TextField(
//             decoration: new InputDecoration.collapsed(hintText: "username"),
//           ),
//         ),
//         new Container(
//           height: 40.0,
//           padding: const EdgeInsets.all(10.0),
//           margin: const EdgeInsets.all(15.0),
//           decoration: new BoxDecoration(
//             color: Colors.white,
//           ),
//           child: new TextField(
//             decoration: new InputDecoration.collapsed(hintText: "password"),
//           ),
//         ),
//       ],
//     );
//
//     var bodyProgress = new Container(
//       child: new Stack(
//         children: <Widget>[
//           body,
//           new Container(
//             alignment: AlignmentDirectional.center,
//             decoration: new BoxDecoration(
//               color: Colors.white70,
//             ),
//             child: new Container(
//               decoration: new BoxDecoration(
//                   color: Colors.blue[100],
//                   borderRadius: new BorderRadius.circular(10.0)),
//               width: 300.0,
//               height: 200.0,
//               alignment: AlignmentDirectional.center,
//               child: new Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   new Center(
//                     child: new SizedBox(
//                       height: 50.0,
//                       width: 50.0,
//                       child: new CircularProgressIndicator(
//                         value: null,
//                         strokeWidth: 7.0,
//                       ),
//                     ),
//                   ),
//                   new Container(
//                     margin: const EdgeInsets.only(top: 25.0),
//                     child: new Center(
//                       child: new Text(
//                         "loading.. wait...",
//                         style: new TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text(widget.title),
//       ),
//       body: new Container(
//           decoration: new BoxDecoration(color: Colors.blue[200]),
//           child: _loading ? bodyProgress : body),
//       floatingActionButton: new FloatingActionButton(
//         onPressed: _onLoading,
//         tooltip: 'Loading',
//         child: new Icon(Icons.check),
//       ),
//     );
//   }
// }
