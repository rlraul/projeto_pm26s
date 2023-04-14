import 'package:flutter/material.dart';
import 'package:projeto/model/ponto_turistico.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FiltroPontosTuristicosPage extends StatefulWidget {
  static const routeName = '/filtro';
  static const chaveCampoOrdenacao = 'campoOrdenacao';
  static const chaveUsarOrdemDecrescente = 'usarOrdemDecrescente';
  static const chaveFiltroDescricao = 'filtroDescricao';

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPontosTuristicosPage> {
  final _camposParaOrdenacao = {
    PontoTutistico.CAMPO_ID: 'Código',
    PontoTutistico.CAMPO_DESCRICAO: 'Descrição',
    PontoTutistico.CAMPO_DATA_INC: 'Prazo'
  };
  late final SharedPreferences _prefs;
  final _descricaoController = TextEditingController();
  String _campoOrdenacao = PontoTutistico.CAMPO_ID;
  bool _usarOrdemDecrescente = false;
  bool _alterouValores = false;

  @override
  void initState() {
    super.initState();
    _carregarSharedPreferences();
  }

  void _carregarSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _campoOrdenacao =
          _prefs.getString(FiltroPontosTuristicosPage.chaveCampoOrdenacao) ?? PontoTutistico.CAMPO_ID;
      _usarOrdemDecrescente =
          _prefs.getBool(FiltroPontosTuristicosPage.chaveUsarOrdemDecrescente) == true;
      _descricaoController.text =
          _prefs.getString(FiltroPontosTuristicosPage.chaveFiltroDescricao) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Filtro e Ordenação'),
        ),
        body: _criarBody(),
      ),
      onWillPop: _onVoltarClick,
    );
  }

  Widget _criarBody() => ListView(
    children: [
      Padding(
        padding: EdgeInsets.only(left: 10, top: 10),
        child: Text('Campo para ordenação'),
      ),
      for (final campo in _camposParaOrdenacao.keys)
        Row(
          children: [
            Radio(
              value: campo,
              groupValue: _campoOrdenacao,
              onChanged: _onCampoOrdenacaoChanged,
            ),
            Text(_camposParaOrdenacao[campo]!),
          ],
        ),
      Divider(),
      Row(
        children: [
          Checkbox(
            value: _usarOrdemDecrescente,
            onChanged: _onUsarOrdemDecrescenteChanged,
          ),
          Text('Usar ordem decrescente'),
        ],
      ),
      Divider(),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Descrição começa com',
          ),
          controller: _descricaoController,
          onChanged: _onFiltroDescricaoChanged,
        ),
      ),
    ],
  );

  void _onCampoOrdenacaoChanged(String? valor) {
    _prefs.setString(FiltroPontosTuristicosPage.chaveCampoOrdenacao, valor!);
    _alterouValores = true;
    setState(() {
      _campoOrdenacao = valor;
    });
  }

  void _onUsarOrdemDecrescenteChanged(bool? valor) {
    _prefs.setBool(FiltroPontosTuristicosPage.chaveUsarOrdemDecrescente, valor!);
    _alterouValores = true;
    setState(() {
      _usarOrdemDecrescente = valor;
    });
  }

  void _onFiltroDescricaoChanged(String? valor) {
    _prefs.setString(FiltroPontosTuristicosPage.chaveFiltroDescricao, valor ?? '');
    _alterouValores = true;
  }

  Future<bool> _onVoltarClick() async {
    Navigator.of(context).pop(_alterouValores);
    return true;
  }
}