// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'newpasswordModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewpasswordModel _$NewpasswordModelFromJson(Map<String, dynamic> json) =>
    NewpasswordModel(
      emailOrPhone: json['emailOrPhone'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$NewpasswordModelToJson(NewpasswordModel instance) =>
    <String, dynamic>{
      'emailOrPhone': instance.emailOrPhone,
      'password': instance.password,
    };
