// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loginModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
      emailOrPhone: json['emailOrPhone'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'emailOrPhone': instance.emailOrPhone,
      'password': instance.password,
    };
