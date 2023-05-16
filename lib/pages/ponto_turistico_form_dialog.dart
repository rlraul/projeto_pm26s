import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
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

  Position? _localizacaoAtual;

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
          ElevatedButton(
              onPressed: _abrirMapaExterno,
              child: Text('Abrir local no Google Maps')
          ),
          ElevatedButton(
              onPressed: () {},
              child: Text('Abrir local no aplicativo')
          ),
        ],
      ),
    );
  }

  Future<bool> _obterLocalizacaoAtual() async{
    bool servicoHabilitado = await _servicoHabilitado();
    if(!servicoHabilitado){
      return false;
    }
    bool permissoesPermitidas = await _permissoesPermitidas();
    if(!permissoesPermitidas){
      return false;
    }
    _localizacaoAtual = await Geolocator.getCurrentPosition();
    return true;
  }

  void _abrirMapaExterno() async{
    bool obteveLocalizacaoAtual = await _obterLocalizacaoAtual();

    if (obteveLocalizacaoAtual) {
      MapsLauncher.launchCoordinates(
          _localizacaoAtual!.latitude, _localizacaoAtual!.longitude);
    }
  }

  Future<bool> _servicoHabilitado() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado){
      await _mostrarDialogMensagem('Para utilizar esse recurso, você deverá habilitar o serviço'
          ' de localização');
      Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }
  Future<bool> _permissoesPermitidas() async {
    LocationPermission permissao = await Geolocator.checkPermission();
    if(permissao == LocationPermission.denied){
      permissao = await Geolocator.requestPermission();
      if(permissao == LocationPermission.denied){
        _mostrarMensagem('Não será possível utilizar o recurso '
            'por falta de permissão');
      }
    }
    if(permissao == LocationPermission.deniedForever){
      await _mostrarDialogMensagem('Para utilizar esse recurso, você deverá acessar '
          'as configurações do app para permitir a utilização do serviço de localização');
      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }
  void _mostrarMensagem(String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _mostrarDialogMensagem(String mensagem) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK')
          )
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