import 'package:flutter/material.dart';

class ListaPontosTuristicos extends StatelessWidget {
  const ListaPontosTuristicos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: null, //_criarBody(),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      title: Text('Lista de Pontos Turísticos'),
      actions: [
        IconButton(
            onPressed: null,//_abrirPaginaFiltro,
            icon: Icon(Icons.filter_list)),
      ],
    );
  }

  // Widget _criarBody() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Text(
  //           'Pontos turísticos!',
  //           style: TextStyle(fontSize: 20),
  //           textAlign: TextAlign.center,
  //         ),
  //         SizedBox(height: 30),
  //         ElevatedButton(
  //           onPressed: () {
  //             // Navegue para a página de cadastro de pontos turísticos.
  //           },
  //           child: Text('Cadastrar ponto turístico'),
  //         ),
  //         SizedBox(height: 10),
  //         TextButton(
  //           onPressed: () {
  //           },
  //           child: Text('Ver lista de pontos turísticos'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}