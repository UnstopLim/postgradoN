
import 'package:json_annotation/json_annotation.dart';

part 'token_models.g.dart';

@JsonSerializable()
class TokenModels
{
   @JsonKey(name: "status")
   final String status;
   @JsonKey(name: 'data')
   final Data data;
   TokenModels({required this.status,required this.data});
   factory TokenModels.fromJson(Map<String,dynamic> json) =>
       _$TokenModelsFromJson(json);
   Map<String,dynamic> toJson() => _$TokenModelsToJson(this);
}

@JsonSerializable()
class Data
{
    final String token;
    final String ttlToken;
    Data({required this.token,required this.ttlToken});
    factory Data.fromJson(Map<String,dynamic> json) =>
        _$DataFromJson(json);

    Map<String,dynamic> toJson() => _$DataToJson(this);
}
