// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      bio: json['bio'] as String,
      emailOrPhone: json['emailOrPhone'] as String,
      name: json['name'] as String,
      userName: json['userName'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'bio': instance.bio,
      'image': instance.image,
      'emailOrPhone': instance.emailOrPhone,
      'name': instance.name,
      'userName': instance.userName,
    };
