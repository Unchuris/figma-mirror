import 'package:json_annotation/json_annotation.dart';

part 'fileResponse.g.dart';

@JsonSerializable()
class FileResponse extends Object {
  final String name;
  final String lastModified;
  final String thumbnailUrl;
  final String version;
  final Document document;

  FileResponse(
      this.name,
      this.lastModified,
      this.thumbnailUrl,
      this.version,
      this.document,
  );

  factory FileResponse.fromJson(Map<String, dynamic> json) => _$FileResponseFromJson(json);
}

@JsonSerializable()
class Document extends Object {
  final String id;
  final String name;
  final String type;
  final List<Page> children;

  Document(
      this.id,
      this.name,
      this.type,
      this.children
  );

  factory Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);
}

@JsonSerializable()
class Page extends Object {
  final String id;
  final String name;
  final String type;
  final List<Frame> children;
  final String prototypeStartNodeID;

  Page(
      this.id,
      this.name,
      this.type,
      this.children,
      this.prototypeStartNodeID,
  );

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}

@JsonSerializable()
class Frame extends Object {
  final String id;
  final String name;
  final String type;
  final String blendMode;
  final List<Element> children;
  final AbsoluteBoundingBox absoluteBoundingBox;

  Frame(
      this.id,
      this.name,
      this.type,
      this.blendMode,
      this.children,
      this.absoluteBoundingBox,
  );

  factory Frame.fromJson(Map<String, dynamic> json) => _$FrameFromJson(json);
}

@JsonSerializable()
class Element extends Object {
  final String id;
  final String type;
  final String name;
  final AbsoluteBoundingBox absoluteBoundingBox;
  final String transitionNodeID;
  final List<Element> children;

  Element(
      this.id,
      this.name,
      this.type,
      this.absoluteBoundingBox,
      this.transitionNodeID,
      this.children,
  );

  factory Element.fromJson(Map<String, dynamic> json) => _$ElementFromJson(json);
}

@JsonSerializable()
class AbsoluteBoundingBox extends Object {
  final double x;
  final double y;
  final double width;
  final double height;

  AbsoluteBoundingBox(
      this.x,
      this.y,
      this.width,
      this.height,
  );

  factory AbsoluteBoundingBox.fromJson(Map<String, dynamic> json) => _$AbsoluteBoundingBoxFromJson(json);
}
