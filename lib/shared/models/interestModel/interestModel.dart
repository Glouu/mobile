import 'package:gloou/shared/models/interestModel/addinterestModel/addinterestModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'interestModel.g.dart';

@JsonSerializable()
class InterestModel {
  late List<AddinterestModel> data;

  InterestModel({
    required this.data,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) =>
      _$InterestModelFromJson(json);
  Map<String, dynamic> toJson() => _$InterestModelToJson(this);
}
