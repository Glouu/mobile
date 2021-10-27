import 'package:json_annotation/json_annotation.dart';

part 'normalmediaModel.g.dart';

@JsonSerializable()
class NormalmediaModel {
  final String caption;
  final String scheduledDate;
  final String type;
  final bool isText;
  final bool allowComment;
  NormalmediaModel({
    required this.scheduledDate,
    required this.type,
    required this.allowComment,
    required this.caption,
    required this.isText,
  });
  factory NormalmediaModel.fromJson(Map<String, dynamic> json) =>
      _$NormalmediaModelFromJson(json);
  Map<String, dynamic> toJson() => _$NormalmediaModelToJson(this);
}
