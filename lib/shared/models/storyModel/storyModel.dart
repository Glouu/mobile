import 'package:json_annotation/json_annotation.dart';

part 'storyModel.g.dart';

@JsonSerializable()
class StoryModel {
  final String caption;
  final bool isText;
  StoryModel({
    required this.caption,
    required this.isText,
  });
  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoryModelToJson(this);
}
