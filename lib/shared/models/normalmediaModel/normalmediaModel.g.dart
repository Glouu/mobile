// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'normalmediaModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NormalmediaModel _$NormalmediaModelFromJson(Map<String, dynamic> json) =>
    NormalmediaModel(
      scheduledDate: json['scheduledDate'] as String,
      type: json['type'] as String,
      allowComment: json['allowComment'] as bool,
      caption: json['caption'] as String,
      isText: json['isText'] as bool,
    );

Map<String, dynamic> _$NormalmediaModelToJson(NormalmediaModel instance) =>
    <String, dynamic>{
      'caption': instance.caption,
      'scheduledDate': instance.scheduledDate,
      'type': instance.type,
      'isText': instance.isText,
      'allowComment': instance.allowComment,
    };
