import 'package:figma_mirror/data/entities/fileResponse.dart';

class ActiveElement {

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
  
}