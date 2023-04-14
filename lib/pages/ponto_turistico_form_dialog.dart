import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/ponto_turistico.dart';

class PontoTuristicoDialog extends StatefulWidget{
  final PontoTutistico? pontoTuristicoAtual;

  PontoTuristicoDialog({Key? key, this.pontoTuristicoAtual}) : super(key: key);

  @override
  PontoTuristicoAtualState createState() => PontoTuristicoAtualState();
}

class PontoTuristicoAtualState extends State<PontoTuristicoDialog>{

  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final cidadeController = TextEditingController();
  final paisController = TextEditingController();
  final descricaoController = TextEditingController();
  final dtInclusaoController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyy');

  @override
  void initState(){
    super.initState();
    if ( widget.pontoTuristicoAtual != null){
      nomeController.text = widget.pontoTuristicoAtual!.nome;
      cidadeController.text = widget.pontoTuristicoAtual!.cidade;
      paisController.text = widget.pontoTuristicoAtual!.pais;
      descricaoController.text = widget.pontoTuristicoAtual!.descricao;
      dtInclusaoController.text = widget.pontoTuristicoAtual!.retornarDataInclusaoFormatada;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: this.nomeController,
            decoration: InputDecoration(labelText: 'Nome do ponto turístico'),
            validator: (String? nome) {
              if (nome == null || nome.isEmpty) {
                return 'Campo "Nome" obrigatório';
              }
              return null;
            },
          ),
          TextFormField(
            controller: this.descricaoController,
            decoration: InputDecoration(labelText: 'Descrição do ponto turístico'),
            validator: (String? descricao) {
              if (descricao == null || descricao.isEmpty) {
                return 'Campo "Descrição" obrigatório';
              }
              return null;
            },
          ),
          TextFormField(
            controller: this.cidadeController,
            decoration: InputDecoration(labelText: 'Cidade do ponto turístico'),
            validator: (String? cidade) {
              if (cidade == null || cidade.isEmpty) {
                return 'Campo "Cidade" obrigatório';
              }
              return null;
            },
          ),
          TextFormField(
            controller: this.paisController,
            decoration: InputDecoration(labelText: 'País do ponto turístico'),
            validator: (String? pais) {
              if (pais == null || pais.isEmpty) {
                return 'Campo "País" obrigatório';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  bool dadosValidados() => formKey.currentState!.validate() == true;

  PontoTutistico get novoPontoTuristico => PontoTutistico(
    id: widget.pontoTuristicoAtual?.id,
    nome: nomeController.text,
    cidade: cidadeController.text,
    pais: paisController.text,
    descricao: descricaoController.text,
    data_inclusao: dtInclusaoController.text.isEmpty ? null : _dateFormat.parse(dtInclusaoController.text),
  );

}