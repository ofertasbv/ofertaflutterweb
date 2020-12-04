import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nosso/src/api/constant_api.dart';
import 'package:nosso/src/core/controller/loja_controller.dart';
import 'package:nosso/src/core/model/loja.dart';
import 'package:nosso/src/paginas/loja/loja_detalhes_tab.dart';

class LojaLocation extends StatefulWidget {
  @override
  _LojaLocationState createState() => _LojaLocationState();
}

class _LojaLocationState extends State<LojaLocation> {
  var lojaController = GetIt.I.get<LojaController>();
  final loja = Loja();

  var selectedCard = 'WEIGHT';
  double distanciaKilomentros = 0;

  Geolocator geolocator;
  Position position;

  // Completer<GoogleMapController> completer = Completer<GoogleMapController>();

  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
    getLocation();
    getCurrentLocation();
    lojaController.getAll();
  }

  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }

  MapType mapType = MapType.normal;
  static const LatLng center = const LatLng(-4.253467, -49.944051);

  LatLng lastMapPosition = center;

  button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      child: Icon(icon, size: 36),
    );
  }

  onMapTypeButtonPressedNormal() {
    setState(() {
      mapType = MapType.normal;
    });
  }

  onMapTypeButtonPressedTerra() {
    setState(() {
      mapType = MapType.terrain;
    });
  }

  onMapTypeButtonPressedSatelite() {
    setState(() {
      mapType = MapType.satellite;
    });
  }

  onMapTypeButtonPressedHibrido() {
    setState(() {
      mapType = MapType.hybrid;
    });
  }

  onCamaraMove(CameraPosition position) {
    lastMapPosition = position.target;
  }

  criarMapa(GoogleMapController controller) {
    lojaController.completer.complete(controller);
  }

  markers(Loja p) {
    return Marker(
      markerId: MarkerId(p.nome),
      position: LatLng(p.enderecos[0].latitude, p.enderecos[0].longitude),
      infoWindow: InfoWindow(title: p.nome, snippet: p.enderecos[0].logradouro),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
  }

  static final CameraPosition posicaoCamera = CameraPosition(
    bearing: 192.833,
    target: LatLng(-4.253467, -49.944051),
    tilt: 54,
    zoom: 14.0,
  );

  getLocation() async {
    try {
      geolocator = Geolocator();
      LocationOptions locationOptions =
          LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
      geolocator.getPositionStream(locationOptions).listen((Position position) {
        position = position;
      });
    } catch (e) {
      print('ERROR:$e');
    }
  }

  getCurrentLocation() async {
    Position res = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      position = res;
    });
  }

  Future<void> goToPosition() async {
    final GoogleMapController controller =
        await lojaController.completer.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(posicaoCamera));
  }

  movimentarCamera(double latitude, double longitude) async {
    GoogleMapController googleMapController =
        await lojaController.completer.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 18.0,
          tilt: 30,
        ),
      ),
    );
  }

  calcularDistancia(double latMercado, double longMercado) async {
    return await geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      latMercado,
      longMercado,
    );
  }

  testeDistancia() async {
    double distanceInMeters = await Geolocator()
        .distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Localzação comercial"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            height: double.infinity,
            padding: EdgeInsets.only(top: 0),
            child: Observer(
              builder: (context) {
                List<Loja> lojas = lojaController.lojas;

                if (lojaController.error != null) {
                  return Text("Não foi possível buscar lojas");
                }

                if (lojas == null) {
                  return GoogleMap(
                    onTap: (valor) {
                      print("Lat: ${valor.latitude}, Long: ${valor.longitude}");
                    },
                    indoorViewEnabled: true,
                    mapToolbarEnabled: true,
                    buildingsEnabled: true,
                    tiltGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    rotateGesturesEnabled: true,
                    trafficEnabled: false,
                    onCameraMove: onCamaraMove,
                    mapType: mapType,
                    onMapCreated: criarMapa,
                    initialCameraPosition: CameraPosition(
                        target: position != null
                            ? LatLng(position.latitude, position.longitude)
                            : lastMapPosition,
                        zoom: 13,
                        tilt: 54),
                  );
                }

                allMarkers = lojas.map((p) {
                  return Marker(
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueYellow),
                      infoWindow: InfoWindow(
                        title: p.nome,
                        snippet: p.enderecos[0].logradouro +
                            ", " +
                            p.enderecos[0].numero,
                      ),
                      markerId: MarkerId(p.nome),
                      position: LatLng(p.enderecos[0].latitude ?? 0.0,
                          p.enderecos[0].longitude ?? 0.0),
                      onTap: () {
                        showDialogAlert(context, p);
                      });
                }).toList();

                return GoogleMap(
                  onTap: (valor) {
                    print("Lat: ${valor.latitude}, Long: ${valor.longitude}");
                  },
                  indoorViewEnabled: true,
                  mapToolbarEnabled: true,
                  buildingsEnabled: true,
                  tiltGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  rotateGesturesEnabled: true,
                  trafficEnabled: false,
                  onCameraMove: onCamaraMove,
                  mapType: mapType,
                  onMapCreated: criarMapa,
                  initialCameraPosition: CameraPosition(
                      target: position != null
                          ? LatLng(position.latitude, position.longitude)
                          : lastMapPosition,
                      zoom: 16.0,
                      tilt: 54),
                  markers: Set.of(allMarkers),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60, right: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () {
                      showDialogAlertTypeMap(context);
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Icon(
                      Icons.map,
                      size: 25,
                    ),
                    tooltip: "tipo de mapa",
                    focusElevation: 5,
                    mini: true,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 110,
              color: Colors.transparent,
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.only(bottom: 0),
              child: Observer(
                builder: (context) {
                  List<Loja> lojas = lojaController.lojas;

                  if (lojaController.error != null) {
                    return Text("Não foi possível buscar lojas");
                  }

                  if (lojas == null) {
                    return Center(
                      child: Text("não foi possível carregar lojas"),
                    );
                  }

                  return builderList(lojas);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  builderList(List<Loja> lojas) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: lojas.length,
      itemBuilder: (context, index) {
        Loja p = lojas[index];

        return GestureDetector(
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(
              color: p.nome == selectedCard ? Colors.yellow[200] : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            width: 240,
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 0.9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      ConstantApi.urlArquivoProduto + p.foto,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: ListTile(
                      title: Text(p.nome),
                      subtitle: Icon(Icons.directions_run),
                      trailing: Text("0.0 km"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            selectCard(p.nome);
            movimentarCamera(
              p.enderecos[0].latitude,
              p.enderecos[0].longitude,
            );
          },
        );
      },
    );
  }

  showDialogAlert(BuildContext context, Loja p) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Localização'),
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${p.nome}"),
                Text("${p.enderecos[0].logradouro}, ${p.enderecos[0].numero}"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('DETALHES'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return LojaDetalhesTab(p);
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  showDialogAlertTypeMap(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tipo de mapa'),
          content: Container(
            height: 200,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            ConstantApi.urlNormal,
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                          ),
                        ),
                        Text("Padrão"),
                      ],
                    ),
                  ),
                  onTap: () {
                    onMapTypeButtonPressedNormal();
                    Navigator.of(context).pop();
                  },
                ),
                GestureDetector(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            ConstantApi.urlSatelite,
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                          ),
                        ),
                        Text("Satélite"),
                      ],
                    ),
                  ),
                  onTap: () {
                    onMapTypeButtonPressedSatelite();
                    Navigator.of(context).pop();
                  },
                ),
                GestureDetector(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            ConstantApi.urlRelevo,
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                          ),
                        ),
                        Text(
                          "Híbrido",
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    onMapTypeButtonPressedHibrido();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showToast(String cardTitle, String unit) {
    Fluttertoast.showToast(
      msg:
          "Loja: $cardTitle - $unit - ${distanciaKilomentros.toStringAsPrecision(2)} km",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      fontSize: 16.0,
    );
  }
}
