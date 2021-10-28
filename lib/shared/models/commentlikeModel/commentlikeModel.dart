import 'package:json_annotation/json_annotation.dart';

part 'commentlikeModel.g.dart';

@JsonSerializable()
class CommentlikeModel {
  late String commentId;
  late String postId;

  CommentlikeModel({
    required this.commentId,
    required this.postId,
  });

  factory CommentlikeModel.fromJson(Map<String, dynamic> json) =>
      _$CommentlikeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentlikeModelToJson(this);
}
