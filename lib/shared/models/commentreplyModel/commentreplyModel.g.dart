// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentreplyModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentreplyModel _$CommentreplyModelFromJson(Map<String, dynamic> json) =>
    CommentreplyModel(
      commentId: json['commentId'] as String,
      commenterUserId: json['commenterUserId'] as String,
      postId: json['postId'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$CommentreplyModelToJson(CommentreplyModel instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'commenterUserId': instance.commenterUserId,
      'postId': instance.postId,
      'content': instance.content,
    };
