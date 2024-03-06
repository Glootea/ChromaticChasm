import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';

sealed class _GameObject {
  final Positionable pivot;
  DateTime lastFrameTimestamp = DateTime.now();
  _GameObject(this.pivot);

  void onFrame(Canvas canvas, DateTime frameTimestamp);
}

abstract class _TileGameObject extends _GameObject {
  @override
  // ignore: overridden_fields
  final TilePositionable pivot;
  _TileGameObject(this.pivot) : super(pivot);
}

abstract class StatefulTileGameObject extends _TileGameObject {
  int state;
  final List<Drawable> drawables;
  StatefulTileGameObject(super.pivot, this.drawables, this.state);
}

abstract class StatelessTileGameObject extends _TileGameObject {
  final Drawable drawable;
  StatelessTileGameObject(TilePositionable pivot, this.drawable) : super(pivot);
}

abstract class _GlobalGameObject extends _GameObject {
  _GlobalGameObject(super.pivot);
}

abstract class StatelessGlobalGameObject extends _GlobalGameObject {
  final Drawable drawable;
  StatelessGlobalGameObject(super.pivot, this.drawable);
}

abstract class StatefulGlobalGameObject extends _GlobalGameObject {
  int state;
  final List<Drawable> drawables;
  StatefulGlobalGameObject(super.pivot, this.drawables, this.state);
}

abstract class ComplexGlobalGameObject extends _GameObject {
  ComplexGlobalGameObject(super.pivot, this.children);
  List<dynamic> children;
}
