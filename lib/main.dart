import 'package:flutter/material.dart';

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
    );
  }
}

class HomePage extends StatelessWidget {
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
              'Bem-vindo ao sistema de cadastro de pontos turísticos!',
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
                // Navegue para a página de lista de pontos turísticos.
              },
              child: Text('Ver lista de pontos turísticos'),
            ),
          ],
        ),
      ),
    );
  }
}
