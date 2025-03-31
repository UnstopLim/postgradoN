
import 'package:json_annotation/json_annotation.dart';
part 'CambioModel.g.dart';

@JsonSerializable()
class CambioModel
{
  final String password;
  final String newPassword;
  final String confirmPassword;
  CambioModel({required this.password,required this.newPassword,required this.confirmPassword});
  factory CambioModel.fromJson(Map<String,dynamic> json) =>
      _$CambioModelFromJson(json);

  Map<String,dynamic> toJson() => _$CambioModelToJson(this);
}

