import 'dart:math';
import 'dart:ui';
import 'package:chromatic_chasm/game_elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game_elements/base_classes/transformable.dart';
import 'package:chromatic_chasm/game_elements/camera.dart';
import 'package:vector_math/vector_math.dart';

sealed class Drawable implements Transformable {
  /// [_faces] is [List] of indexes of vertexes in [vertexes]
  ///
  /// [width] is used to scale objects. [width] = max width coordinate of object, located in [Positionable.zero()]
  ///
  /// In constructor all verteces are scaled with k = _width / _vertexes.maxWidth
  Drawable(this._pivot, this._vertexes, this._faces);

  final Positionable _pivot;
  final List<Positionable> _vertexes;
  final List<List<int>> _faces;

  ///Time in milliseconds that one game time unit is. Used to sync movement for devices with different refresh rates
  static const syncTime = 48;

  ///How far the projection plane is from camera
  static const _distanceToCamera = 0.0000000001;
  static late double _canvasSize;
  static void setCanvasSize(Size size) {
    _canvasSize = size.width;
  }

  static const double strokeWidth = 1;
  static const double strokeWidthLight = 0.3;

  void show(Canvas canvas, Camera camera, Paint paint);

  List<Offset> _project2D(List<Positionable> list, Positionable camera) {
    return list.map((point) => _convert3DToOffset(point - camera)).toList();
  }

  Offset _convert3DToOffset(Positionable point) {
    point.z = point.z <= 0 ? 0.5 : point.z; //prevent imaginary draw behing camera

    final x =
        ((_distanceToCamera * point.x / (point.z + _distanceToCamera)) / (_distanceToCamera * 4) + 0.5) * _canvasSize;
    final y =
        (((_distanceToCamera * point.y / (point.z + _distanceToCamera)) / (_distanceToCamera * 4)) + 0.5) * _canvasSize;
    return Offset(x, y);
  }

  ///Use in constructor for permanent effect or in show() for onFrame effect, that will erased after next call
  ///
  ///[scaleToWidth] = max absolute width coordinate of object, located in [Positionable.zero()]
  @override
  void applyTransformation({double? angleX, double? angleY, double? angleZ, double? widthToScale}) {
    _transformedVertexes = [..._vertexes];
    widthToScale != null ? scaleToWidth(widthToScale) : null;
    angleX != null ? rotateX(angleX) : null;
    angleY != null ? rotateY(angleY) : null;
    angleZ != null ? rotateZ(angleZ) : null;
  }

  ///Temporary storage for transformed vertexes
  late List<Positionable> _transformedVertexes = _vertexes.toList();
  List<Positionable> get getGlobalVertexes => _transformedVertexes.map((point) => point + _pivot).toList();

  ///Rotates all points around pivot by angle. If points are in local coordinates, [_pivot] = Positionable.zero()
  @override
  List<Positionable> rotateX(double angle) => _transformedVertexes =
      _transformedVertexes.map((point) => point.rotateX(angle - pi / 2)).expand((element) => element).toList();

  ///Rotates all points around pivot by angle. If points are in local coordinates, [_pivot] = Positionable.zero()
  @override
  List<Positionable> rotateY(double angle) => _transformedVertexes =
      _transformedVertexes.map((point) => point.rotateY(angle - pi / 2)).expand((element) => element).toList();

  ///Rotates all points around pivot by angle. If points are in local coordinates, [_pivot] = Positionable.zero()
  @override
  List<Positionable> rotateZ(double angle) => _transformedVertexes =
      _transformedVertexes.map((point) => point.rotateZ(angle - pi / 2)).expand((element) => element).toList();

  @override
  List<Transformable> scaleToWidth(double width) {
    final maxWidth =
        _transformedVertexes.reduce((value, element) => value.y.abs() > element.y.abs() ? value : element).y.abs();
    final k = width / maxWidth;
    return _transformedVertexes = _transformedVertexes.map((e) => e * k).toList();
  }
}

class Drawable3D extends Drawable {
  Drawable3D(super._pivot, super._vertexes, super._faces);

  @override
  void show(Canvas canvas, Camera camera, Paint paint) {
    for (final (i, face) in _faces.indexed) {
      if (_visible(i, camera)) {
        final projected =
            _project2D(List.generate(face.length, (index) => getGlobalVertexes[face[index]]), camera.pivot);
        canvas.drawPoints(PointMode.polygon, projected, paint);
        canvas.drawPoints(PointMode.lines, [projected.first, projected.last], paint);
      }
    }
  }

  bool _visible(int i, Camera camera) {
    Vector3 normal = _getFaceNormal(i);
    return (_pivot - camera.pivot).dot(normal) > 0;
  }

  Vector3 _getFaceNormal(int faceNumber) {
    final dir = (_transformedVertexes[_faces[faceNumber][1]] - _transformedVertexes[_faces[faceNumber][0]])
        .cross(_transformedVertexes[_faces[faceNumber][2]] - _transformedVertexes[_faces[faceNumber][0]]);
    final normal = dir.normalized();
    return normal;
  }
}

class Drawable2D extends Drawable {
  Drawable2D(super._pivot, super._vertexes, super._faces);

  @override
  void show(Canvas canvas, Camera camera, Paint paint) {
    for (final face in _faces) {
      final projected = _project2D(List.generate(face.length, (index) => getGlobalVertexes[face[index]]), camera.pivot);
      canvas.drawPoints(PointMode.polygon, projected, paint);
      canvas.drawPoints(PointMode.lines, [projected.first, projected.last], paint);
    }
  }
}
