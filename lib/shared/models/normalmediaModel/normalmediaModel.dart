import 'package:json_annotation/json_annotation.dart';

part 'normalmediaModel.g.dart';

@JsonSerializable()
class NormalmediaModel {
  final String caption;
  final bool isText;
  NormalmediaModel({
    required this.caption,
    required this.isText,
  });
  factory NormalmediaModel.fromJson(Map<String, dynamic> json) =>
      _$NormalmediaModelFromJson(json);
  Map<String, dynamic> toJson() => _$NormalmediaModelToJson(this);
}
