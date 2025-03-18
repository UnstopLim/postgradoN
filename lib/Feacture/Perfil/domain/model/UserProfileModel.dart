import 'package:json_annotation/json_annotation.dart';

part 'UserProfileModel.g.dart';

@JsonSerializable()
class UserProfileModel {
  @JsonKey(name: 'id_usuario')
  final String id_usuario;

  @JsonKey(name: 'nombre_usuario')
  final String nombre_usuario;

  @JsonKey(name: 'Persona')  // Asegúrate de usar la misma clave que en el JSON
  final Persona persona;

  UserProfileModel({
    required this.id_usuario,
    required this.nombre_usuario,
    required this.persona,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}

@JsonSerializable()
class Persona {
  final String nombre;
  final String paterno;
  final String materno;
  final String correo;
  final String celular;

  Persona({
    required this.nombre,
    required this.paterno,
    required this.materno,
    required this.correo,
    required this.celular,
  });

  factory Persona.fromJson(Map<String, dynamic> json) =>
      _$PersonaFromJson(json);

  Map<String, dynamic> toJson() => _$PersonaToJson(this);
}