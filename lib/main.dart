import 'package:flutter/material.dart';
import 'package:projeto/pages/filtro_pontos_turisticos_page.dart';
import 'package:projeto/pages/home_page.dart';

void main() {
  runApp(PontosTuristicos());
}

class PontosTuristicos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ponto Turístico',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        FiltroPontosTuristicosPage.routeName: (BuildContext context) => FiltroPontosTuristicosPage(),
      },
    );
  }
}
