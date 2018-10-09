// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fileResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileResponse _$FileResponseFromJson(Map<String, dynamic> json) {
  return FileResponse(
      json['name'] as String,
      json['lastModified'] as String,
      json['thumbnailUrl'] as String,
      json['version'] as String,
      json['document'] == null
          ? null
          : Document.fromJson(json['document'] as Map<String, dynamic>));
}

Map<String, dynamic> _$FileResponseToJson(FileResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'lastModified': instance.lastModified,
      'thumbnailUrl': instance.thumbnailUrl,
      'version': instance.version,
      'document': instance.document
    };

Document _$DocumentFromJson(Map<String, dynamic> json) {
  return Document(
      json['id'] as String,
      json['name'] as String,
      json['type'] as String,
      (json['children'] as List)
          ?.map((e) =>
              e == null ? null : Page.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'children': instance.children
    };

Page _$PageFromJson(Map<String, dynamic> json) {
  return Page(
      json['id'] as String,
      json['name'] as String,
      json['type'] as String,
      (json['children'] as List)
          ?.map((e) =>
              e == null ? null : Frame.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['prototypeStartNodeID'] as String);
}

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'children': instance.children,
      'prototypeStartNodeID': instance.prototypeStartNodeID
    };

Frame _$FrameFromJson(Map<String, dynamic> json) {
  return Frame(
      json['id'] as String,
      json['name'] as String,
      json['type'] as String,
      json['blendMode'] as String,
      (json['children'] as List)
          ?.map((e) =>
              e == null ? null : Element.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$FrameToJson(Frame instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'blendMode': instance.blendMode,
      'children': instance.children
    };

Element _$ElementFromJson(Map<String, dynamic> json) {
  return Element(
      json['id'] as String,
      json['name'] as String,
      json['type'] as String,
      json['absoluteBoundingBox'] == null
          ? null
          : AbsoluteBoundingBox.fromJson(
              json['absoluteBoundingBox'] as Map<String, dynamic>),
      json['transitionNodeID'] as String,
      (json['children'] as List)
          ?.map((e) =>
              e == null ? null : Element.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ElementToJson(Element instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'absoluteBoundingBox': instance.absoluteBoundingBox,
      'transitionNodeID': instance.transitionNodeID,
      'children': instance.children
    };

AbsoluteBoundingBox _$AbsoluteBoundingBoxFromJson(Map<String, dynamic> json) {
  return AbsoluteBoundingBox(
      (json['x'] as num)?.toDouble(),
      (json['y'] as num)?.toDouble(),
      (json['width'] as num)?.toDouble(),
      (json['height'] as num)?.toDouble());
}

Map<String, dynamic> _$AbsoluteBoundingBoxToJson(
        AbsoluteBoundingBox instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height
    };
