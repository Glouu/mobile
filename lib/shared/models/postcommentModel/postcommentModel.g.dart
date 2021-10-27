// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postcommentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostcommentModel _$PostcommentModelFromJson(Map<String, dynamic> json) =>
    PostcommentModel(
      postId: json['postId'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$PostcommentModelToJson(PostcommentModel instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'content': instance.content,
    };
