import 'dart:convert';
import 'package:http/http.dart';
import 'package:projeto/model/cep.dart';

class CepService {

  static const _base_Url = 'https://viacep.com.br/ws/:cep/json/';

  Future<Map<String, dynamic>> findCep(String cep) async{
    final url = _base_Url.replaceAll(':cep', cep);
    final uri = Uri.parse(url);
    final Response response = await get(uri);

    if (response.statusCode != 200){
      throw Exception();
    }

    final decodeBody = jsonDecode(response.body);
    return Map<String, dynamic>.from(decodeBody);
  }

  Future<Cep> findCepAsObject(String cep) async{
    final map = await findCep(cep);
    return Cep.fromJson(map);
  }

}