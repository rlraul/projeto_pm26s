import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto/model/cep.dart';
import 'package:projeto/pages/internal_map_page.dart';
import 'package:projeto/service/cep_service.dart';
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
  final cepController = TextEditingController();
  final ufController = TextEditingController();
  final bairroController = TextEditingController();
  final logradouroController = TextEditingController();
  final paisController = TextEditingController();
  final descricaoController = TextEditingController();
  final dtInclusaoController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyy');

  Cep? _cep;
  final _service = CepService();
  final _formKey = GlobalKey<FormState>();
  var _loading = false;
  final _cepFormater = MaskTextInputFormatter(
      mask: '#####-###',
      filter: {'#' : RegExp(r'[0-9]')}
  );

  Position? _localizacaoAtual;
  LatLng? _posicaoEscolhida;

  @override
  void initState(){
    super.initState();
    if ( widget.pontoTuristicoAtual != null){
      nomeController.text = widget.pontoTuristicoAtual!.nome;
      descricaoController.text = widget.pontoTuristicoAtual!.descricao;
      dtInclusaoController.text = widget.pontoTuristicoAtual!.retornarDataInclusaoFormatada;
      cepController.text = widget.pontoTuristicoAtual!.cep;
      paisController.text = widget.pontoTuristicoAtual!.pais;
      ufController.text = widget.pontoTuristicoAtual!.uf;
      cidadeController.text = widget.pontoTuristicoAtual!.cidade;
      bairroController.text = widget.pontoTuristicoAtual!.bairro;
      logradouroController.text = widget.pontoTuristicoAtual!.logradouro;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
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
              controller: this.cepController,
              decoration: InputDecoration(
                labelText: 'CEP do ponto turístico',
                suffixIcon: _loading ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(strokeWidth: 2,),
                ) : IconButton(
                    onPressed: _findCep,
                    icon: const Icon(Icons.search)
                ),
              ),
              validator: (String? cep) {
                if (cep == null || cep.isEmpty) {
                  return 'Campo "CEP" obrigatório';
                }
                if (cep == null || cep.isEmpty || !_cepFormater.isFill()) {
                  return 'Informe um CEP válido!';
                }
                return null;
              },
              inputFormatters: [_cepFormater],
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
            TextFormField(
              controller: this.ufController,
              decoration: InputDecoration(labelText: 'UF do ponto turístico'),
              validator: (String? uf) {
                if (uf == null || uf.isEmpty) {
                  return 'Campo "UF" obrigatório';
                }
                if (uf.length != 2) {
                  return 'Campo "UF" deve conter 2 caracteres';
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
              controller: this.bairroController,
              decoration: InputDecoration(labelText: 'Bairro do ponto turístico'),
              validator: (String? bairro) {
                if (bairro == null || bairro.isEmpty) {
                  return 'Campo "Bairro" obrigatório';
                }
                return null;
              },
            ),
            TextFormField(
              controller: this.logradouroController,
              decoration: InputDecoration(labelText: 'Logradouro do ponto turístico'),
              validator: (String? logradouro) {
                if (logradouro == null || logradouro.isEmpty) {
                  return 'Campo "Logradouro" obrigatório';
                }
                return null;
              },
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _abrirMapaExterno,
                    child: Text('Google Maps'),
                  ),
                  ElevatedButton(
                    onPressed: _abrirMapaInterno,
                    child: Text('Mapa Interno'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _findCep() async {
    setState(() {
      _loading = true;
    });
    try{
      _cep = await _service.findCepAsObject(_cepFormater.getUnmaskedText());
      _AlimentaCamposEndereco(_cep);
    } catch(e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao consultar CEP. O erro foi: ${e.toString()}')
      ));
    }
    setState(() {
      _loading = false;
    });
  }

  void _AlimentaCamposEndereco(Cep? cep) {
    cepController.text = cep!.cep.toString();
    ufController.text = cep!.uf.toString();
    cidadeController.text = cep!.localidade.toString();
    bairroController.text = cep!.bairro.toString();
    logradouroController.text = cep!.logradouro.toString();
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
      MapsLauncher.launchCoordinates(_localizacaoAtual!.latitude, _localizacaoAtual!.longitude);
    }
  }

  void _abrirMapaInterno() async{
    bool obteveLocalizacaoAtual = await _obterLocalizacaoAtual();

    if (obteveLocalizacaoAtual)
      Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) => InternalMapPage(
          latitude: _localizacaoAtual!.latitude,
          longitude: _localizacaoAtual!.longitude,
        ),
      ),
      );
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
    descricao: descricaoController.text,
    data_inclusao: dtInclusaoController.text.isEmpty ? null : _dateFormat.parse(dtInclusaoController.text),
    cep: cepController.text,
    pais: paisController.text,
    uf: ufController.text,
    cidade: cidadeController.text,
    bairro: bairroController.text,
    logradouro: logradouroController.text,
    latitude: double.parse(latitudeController.text),
    longitude: double.parse(longitudeController.text),
  );

}