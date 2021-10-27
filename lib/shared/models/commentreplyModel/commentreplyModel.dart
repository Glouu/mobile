import 'package:json_annotation/json_annotation.dart';

part 'commentreplyModel.g.dart';

@JsonSerializable()
class CommentreplyModel {
  late String commentId;
  late String commenterUserId;
  late String postId;
  late String content;

  CommentreplyModel({
    required this.commentId,
    required this.commenterUserId,
    required this.postId,
    required this.content,
  });

  factory CommentreplyModel.fromJson(Map<String, dynamic> json) =>
      _$CommentreplyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentreplyModelToJson(this);
}
