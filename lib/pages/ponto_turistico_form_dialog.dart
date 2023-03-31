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
  final descricaoController = TextEditingController();
  final dtInclusaoController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyy');

  @override
  void initState(){
    super.initState();
    if ( widget.pontoTuristicoAtual != null){
      nomeController.text = widget.pontoTuristicoAtual!.nome;
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
          )
        ],
      ),
    );
  }

  bool dadosValidados() => formKey.currentState!.validate() == true;

  PontoTutistico get novoPontoTuristico => PontoTutistico(
    id: widget.pontoTuristicoAtual?.id ?? 0,
    nome: nomeController.text,
    descricao: descricaoController.text,
    data_inclusao: dtInclusaoController.text.isEmpty ? null : _dateFormat.parse(dtInclusaoController.text),
  );

}