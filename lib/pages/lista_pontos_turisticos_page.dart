import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto/model/ponto_turistico.dart';
import 'package:projeto/pages/ponto_turistico_form_dialog.dart';

class ListaPontosTuristicos extends StatefulWidget {
  const ListaPontosTuristicos({super.key});

  @override
  _ListaPontosTuristicosState createState() => _ListaPontosTuristicosState();
}

class _ListaPontosTuristicosState extends State<ListaPontosTuristicos> {

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  final pontosTuristicos = <PontoTutistico>[];

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
    if (pontosTuristicos.isEmpty) {
      return const Center(
        child: Text('Nenhum ponto turístico cadastrado!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      );
    }
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        final pontoTuristico = pontosTuristicos[index];
        return PopupMenuButton(
          child: ListTile(
            title: Text('${pontoTuristico.id} - ${pontoTuristico.nome} - ${pontoTuristico.descricao} - ${pontoTuristico.retornarDataInclusaoFormatada}'),
          ),
          itemBuilder: (BuildContext context) => criarItensMenuPopup(),
          onSelected: (String valorSelecionado) {
            if (valorSelecionado == ACAO_EDITAR){
              _abrirForm(pontoTutisticoAtual: pontoTuristico, indice: index);
            }else{
              _excluir(index);
            }
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: pontosTuristicos.length
    );
  }

  List<PopupMenuEntry<String>> criarItensMenuPopup(){
    return[
      PopupMenuItem<String>(
        value: ACAO_EDITAR,
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Editar'),
            )
          ],
        )
      ),
      PopupMenuItem<String>(
        value: ACAO_EXCLUIR,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Excluir'),
            )
          ],
        )
      )
    ];
  }

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

  void _abrirForm({PontoTutistico? pontoTutisticoAtual, int? indice}) {
    final key = GlobalKey<PontoTuristicoAtualState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(pontoTutisticoAtual == null ? 'Novo Ponto Turístico' : 'Editar Ponto Turístico ${pontoTutisticoAtual.nome}'),
          content: PontoTuristicoDialog(
            key: key, pontoTuristicoAtual: pontoTutisticoAtual),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar')
            ),
            TextButton(
              onPressed: () {
                if (key.currentState != null && key.currentState!.dadosValidados()){
                  setState(() {
                    final novoPontoTuristico = key.currentState!.novoPontoTuristico;
                    if (indice == null){
                      novoPontoTuristico.id = ++ _ultimoId;
                    } else {
                      pontosTuristicos[indice] = novoPontoTuristico;
                    }
                    novoPontoTuristico.data_inclusao = DateTime.now();
                    pontosTuristicos.add(novoPontoTuristico);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Salvar'),
            )
          ],
        );
      }
    );
  }
}