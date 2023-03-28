import 'package:flutter/material.dart';

class ListaPontosTuristicos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pontos Turísticos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pontos turísticos!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navegue para a página de cadastro de pontos turísticos.
              },
              child: Text('Cadastrar ponto turístico'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
              },
              child: Text('Ver lista de pontos turísticos'),
            ),
          ],
        ),
      ),
    );
  }
}