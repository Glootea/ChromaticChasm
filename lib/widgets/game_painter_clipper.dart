import 'package:flutter/material.dart';

class GamePainterClipper extends CustomClipper<Rect> {
  Size size;
  GamePainterClipper(this.size);
  @override
  Rect getClip(Size _) {
    return Rect.fromLTWH(0, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return oldClipper != this;
  }
}
