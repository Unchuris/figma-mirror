import 'package:json_annotation/json_annotation.dart';

part 'filesResponse.g.dart';

@JsonSerializable()
class FilesResponse extends Object {
  final Meta meta;

  FilesResponse(this.meta);

  factory FilesResponse.fromJson(Map<String, dynamic> json) =>
      _$FilesResponseFromJson(json);
}

@JsonSerializable()
class Meta extends Object {
  final List<File> files;

  Meta(this.files);

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}

@JsonSerializable()
class File extends Object {
  final String key;
  final String name;

  File(this.key, this.name);

  factory File.fromJson(Map<String, dynamic> json) => _$FileFromJson(json);
}
