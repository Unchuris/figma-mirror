import 'package:figma_mirror/data/entities/image.dart';

class ActiveElement {

  final double x;
  final double y;
  final double width;
  final double height;
  final String linkToNewImage;
  final MyImage parent;

  ActiveElement(
      this.x,
      this.y,
      this.width,
      this.height,
      this.linkToNewImage,
      this.parent,
  );
  
}