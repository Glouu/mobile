import 'package:json_annotation/json_annotation.dart';

part 'postcommentModel.g.dart';

@JsonSerializable()
class PostcommentModel {
  late String postId;
  late String content;

  PostcommentModel({
    required this.postId,
    required this.content,
  });

  factory PostcommentModel.fromJson(Map<String, dynamic> json) =>
      _$PostcommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostcommentModelToJson(this);
}
