import 'package:flutter/material.dart';

class GamePainterClipper extends CustomClipper<Rect> {
  Size gameSize;
  GamePainterClipper(this.gameSize);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, gameSize.width, gameSize.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return oldClipper != this;
  }
}
