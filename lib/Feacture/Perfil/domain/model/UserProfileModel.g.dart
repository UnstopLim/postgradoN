// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserProfileModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id_usuario: json['id_usuario'] as String,
      nombre_usuario: json['nombre_usuario'] as String,
      persona: Persona.fromJson(json['Persona'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'id_usuario': instance.id_usuario,
      'nombre_usuario': instance.nombre_usuario,
      'Persona': instance.persona,
    };

Persona _$PersonaFromJson(Map<String, dynamic> json) => Persona(
      nombre: json['nombre'] as String,
      paterno: json['paterno'] as String,
      materno: json['materno'] as String,
      correo: json['correo'] as String,
      celular: json['celular'] as String,
    );

Map<String, dynamic> _$PersonaToJson(Persona instance) => <String, dynamic>{
      'nombre': instance.nombre,
      'paterno': instance.paterno,
      'materno': instance.materno,
      'correo': instance.correo,
      'celular': instance.celular,
    };
