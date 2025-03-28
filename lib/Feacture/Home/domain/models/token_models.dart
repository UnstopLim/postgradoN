import 'package:json_annotation/json_annotation.dart';

part 'token_models.g.dart';

@JsonSerializable()
class Data {
  final String? token;
  final String? ttlToken;

  Data({required this.token, required this.ttlToken});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json['token']?.toString(),  // Convierte cualquier valor a String
      ttlToken: json['ttlToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
