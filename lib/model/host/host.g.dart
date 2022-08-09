// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Host _$HostFromJson(Map<String, dynamic> json) => Host(
      id: json['id'] as int?,
      host: json['host'] as String,
      pass: json['pass'] as String,
      name: json['name'] as String,
      port: json['port'] as String,
    );

Map<String, dynamic> _$HostToJson(Host instance) => <String, dynamic>{
      'id': instance.id,
      'host': instance.host,
      'port': instance.port,
      'name': instance.name,
      'pass': instance.pass,
    };
