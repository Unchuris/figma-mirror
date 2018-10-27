import 'package:figma_mirror/data/entities/fileResponse.dart';
import 'package:json_annotation/json_annotation.dart';

part 'active_element.g.dart';

@JsonSerializable()
class ActiveElement extends Object {

  final double x;
  final double y;
  final double width;
  final double height;
  final String linkToNewFrame;
  final Frame parent;

  ActiveElement(
      this.x,
      this.y,
      this.width,
      this.height,
      this.linkToNewFrame,
      this.parent,
  );

  factory ActiveElement.fromJson(Map<String, dynamic> json) => _$ActiveElementFromJson(json);

  Map toJson() => _$ActiveElementToJson(this);
}
