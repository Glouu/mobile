import 'package:json_annotation/json_annotation.dart';

part 'postidModel.g.dart';

@JsonSerializable()
class PostidModel {
  late String postId;

  PostidModel({
    required this.postId,
  });

  factory PostidModel.fromJson(Map<String, dynamic> json) =>
      _$PostidModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostidModelToJson(this);
}
