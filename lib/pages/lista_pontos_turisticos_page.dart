import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto/dao/ponto_turistico_dao.dart';
import 'package:projeto/model/ponto_turistico.dart';
import 'package:projeto/pages/ponto_turistico_form_dialog.dart';

class ListaPontosTuristicos extends StatefulWidget {
  const ListaPontosTuristicos({super.key});

  @override
  _ListaPontosTuristicosState createState() => _ListaPontosTuristicosState();
}

class _ListaPontosTuristicosState extends State<ListaPontosTuristicos> {

  //tatic const ACAO_EDITAR = 'editar';
  //static const ACAO_EXCLUIR = 'excluir';

  final pontosTuristicos = <PontoTutistico>[];
  final _dao = PontoTuristicoDao();

  int _ultimoId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Cadastrar Ponto Turístico',
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      title: Text('Lista de Pontos Turísticos'),
      actions: [
        IconButton(
            onPressed: null,
            icon: Icon(Icons.filter_list)),
      ],
    );
  }

  Widget _criarBody() {
    if (pontosTuristicos.isEmpty || pontosTuristicos == null) {
      return const Center(
        child: Text('Nenhum ponto turístico cadastrado!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      );
    }
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final pontoTuristico = pontosTuristicos[index];
          return Card(
            child: Column (
              mainAxisSize: MainAxisSize.min,
              children: <Widget> [
                ListTile(
                  leading: Icon(Icons.album),
                  title: Text(pontoTuristico.nome),
                  subtitle: Text(pontoTuristico.descricao),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          _abrirForm(pontoTutistico: pontoTuristico);
                        },
                        child: Text('Editar')
                    ),
                    TextButton(
                        onPressed: () {
                          _excluir(index);
                        },
                        child: Text('Excluir')
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: pontosTuristicos.length
    );
  }

  // List<PopupMenuEntry<String>> criarItensMenuPopup(){
  //   return[
  //     PopupMenuItem<String>(
  //       value: ACAO_EDITAR,
  //       child: Row(
  //         children: [
  //           Icon(Icons.edit, color: Colors.black),
  //           Padding(
  //             padding: EdgeInsets.only(left: 10),
  //             child: Text('Editar'),
  //           )
  //         ],
  //       )
  //     ),
  //     PopupMenuItem<String>(
  //       value: ACAO_EXCLUIR,
  //       child: Row(
  //         children: [
  //           Icon(Icons.delete, color: Colors.red),
  //           Padding(
  //             padding: EdgeInsets.only(left: 10),
  //             child: Text('Excluir'),
  //           )
  //         ],
  //       )
  //     )
  //   ];
  // }

  void _excluir(int indice){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red,),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('ATENÇÃO'),
              ),
            ],
          ),
          content: Text('Esse registro será deletado definitivamente'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar')
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  pontosTuristicos.removeAt(indice);
                });
              },
              child: Text('OK')
            )
          ],
        );
      }
    );
  }

  void _abrirForm({PontoTutistico? pontoTutistico}) {
    final key = GlobalKey<PontoTuristicoAtualState>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          pontoTutistico == null ? 'Nova Tarefa' : 'Alterar Tarefa ${pontoTutistico.id}',
        ),
        content: PontoTuristicoDialog(
          key: key,
          pontoTuristicoAtual: pontoTutistico,
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Salvar'),
            onPressed: () {
              if (key.currentState?.dadosValidados() != true) {
                return;
              }
              Navigator.of(context).pop();
              final novoPontoTuristico = key.currentState!.novoPontoTuristico;
              _dao.salvar(novoPontoTuristico).then((success) {
                if (success) {
                  //_atualizarLista();
                }
              });
              //_atualizarLista();
            },
          ),
        ],
      ),
    );
  }
}