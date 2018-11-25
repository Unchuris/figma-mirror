// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filesResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilesResponse _$FilesResponseFromJson(Map<String, dynamic> json) {
  return FilesResponse(json['meta'] == null
      ? null
      : Meta.fromJson(json['meta'] as Map<String, dynamic>));
}

Map<String, dynamic> _$FilesResponseToJson(FilesResponse instance) =>
    <String, dynamic>{'meta': instance.meta};

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return Meta((json['files'] as List)
      ?.map((e) => e == null ? null : File.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$MetaToJson(Meta instance) =>
    <String, dynamic>{'files': instance.files};

File _$FileFromJson(Map<String, dynamic> json) {
  return File(json['key'] as String, json['name'] as String);
}

Map<String, dynamic> _$FileToJson(File instance) =>
    <String, dynamic>{'key': instance.key, 'name': instance.name};
