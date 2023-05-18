
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto/model/ponto_turistico.dart';

class InternalMapPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  InternalMapPage({Key? ke, required this.latitude, required this.longitude}) : super(key: ke);

  @override
  _InternalMapPageState createState() => _InternalMapPageState();
}

class _InternalMapPageState extends State<InternalMapPage> {
  final _mapController = Completer<GoogleMapController>();
  StreamSubscription<Position>? _subscription;

  @override
  void initState(){
    super.initState();
    _monitorarLocalizacao();
  }

  @override
  void dispose(){
    super.dispose();
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Localização do Ponto Turístico'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
          CameraPosition(
            target: LatLng(widget.latitude, widget.longitude), //Posição inicial ao abrir o mapa
            zoom: 15
          ),
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        onTap: (LatLng latLng) {
          setState(() {
            // Armazena a latitude e longitude selecionadas pelo usuário
          });
        },
        myLocationEnabled: true,
      ),
    );
  }

  void _monitorarLocalizacao(){
    final LocationSettings locationSettings = LocationSettings(accuracy: LocationAccuracy.high,
        distanceFilter: 100);
    _subscription = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) async {
      final controller = await _mapController.future;
      final zoom = await controller.getZoomLevel();
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(widget.latitude, widget.longitude),
        zoom: zoom,
      )));
    });
  }

}