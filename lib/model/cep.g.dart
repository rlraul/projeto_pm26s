// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cep.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cep _$CepFromJson(Map<String, dynamic> json) => Cep(
      json['cep'] as String?,
      json['logradouro'] as String?,
      json['complemento'] as String?,
      json['bairro'] as String?,
      json['localidade'] as String?,
      json['uf'] as String?,
      json['ibge'] as String?,
      json['gia'] as String?,
      json['ddd'] as String?,
      json['siafi'] as String?,
    );

Map<String, dynamic> _$CepToJson(Cep instance) => <String, dynamic>{
      'cep': instance.cep,
      'logradouro': instance.logradouro,
      'complemento': instance.complemento,
      'bairro': instance.bairro,
      'localidade': instance.localidade,
      'uf': instance.uf,
      'ibge': instance.ibge,
      'gia': instance.gia,
      'ddd': instance.codigoDeArea,
      'siafi': instance.siafi,
    };
