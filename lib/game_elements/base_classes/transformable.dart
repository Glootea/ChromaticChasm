abstract interface class Transformable {
  void applyTransformation({double? angleX, double? angleY, double? angleZ, double? widthToScale});
  List<Transformable> rotateX(double angle);
  List<Transformable> rotateY(double angle);
  List<Transformable> rotateZ(double angle);
  List<Transformable> scaleToWidth(double width);
}
