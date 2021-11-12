import 'package:json_annotation/json_annotation.dart';

part 'addinterestModel.g.dart';

@JsonSerializable()
class AddinterestModel {
  late String category, interestID, name;

  AddinterestModel({
    required this.category,
    required this.interestID,
    required this.name,
  });

  factory AddinterestModel.fromJson(Map<String, dynamic> json) =>
      _$AddinterestModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddinterestModelToJson(this);
}
