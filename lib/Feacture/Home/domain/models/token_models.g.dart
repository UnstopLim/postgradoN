// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenModels _$TokenModelsFromJson(Map<String, dynamic> json) => TokenModels(
      status: json['status'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TokenModelsToJson(TokenModels instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      token: json['token'] as String,
      ttlToken: json['ttlToken'] as String,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'token': instance.token,
      'ttlToken': instance.ttlToken,
    };
