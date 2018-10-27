// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveElement _$ActiveElementFromJson(Map<String, dynamic> json) {
  return ActiveElement(
      (json['x'] as num)?.toDouble(),
      (json['y'] as num)?.toDouble(),
      (json['width'] as num)?.toDouble(),
      (json['height'] as num)?.toDouble(),
      json['linkToNewFrame'] as String,
      json['parent'] == null
          ? null
          : Frame.fromJson(json['parent'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ActiveElementToJson(ActiveElement instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height,
      'linkToNewFrame': instance.linkToNewFrame,
      'parent': instance.parent
    };
