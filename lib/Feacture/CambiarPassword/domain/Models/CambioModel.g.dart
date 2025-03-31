// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CambioModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CambioModel _$CambioModelFromJson(Map<String, dynamic> json) => CambioModel(
      password: json['password'] as String,
      newPassword: json['newPassword'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );

Map<String, dynamic> _$CambioModelToJson(CambioModel instance) =>
    <String, dynamic>{
      'password': instance.password,
      'newPassword': instance.newPassword,
      'confirmPassword': instance.confirmPassword,
    };
