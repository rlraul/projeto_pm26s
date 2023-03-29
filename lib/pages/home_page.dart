import 'package:flutter/material.dart';

import 'lista_pontos_turisticos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pontos Turisticos")),
      body: null,
      //Side Menu
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
                child: Text("")
            ),
            //Lista de itens do side menu
            ListTile(
              title: const Text("Lista de Pontos Turísticos"),
              leading: Icon(Icons.list_sharp),
              onTap: () {
                //Abrirá a ListaPontosTuristicos
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ListaPontosTuristicos()));
              },
            )
          ],
        ),
      ),
    );
  }

}