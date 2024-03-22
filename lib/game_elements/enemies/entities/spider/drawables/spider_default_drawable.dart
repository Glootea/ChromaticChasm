import 'package:chromatic_chasm/game_elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game_elements/base_classes/positionable.dart';

class SpiderDefaultDrawable extends Drawable2D {
  SpiderDefaultDrawable(Positionable pivot) : super(pivot, _verteces, _faces);

  static final List<Positionable> _verteces = [
    Positionable(-0.04947704076766968, -1.0, 0.0),
    Positionable(-0.04947704076766968, 0.0, -7.010334002188756e-08),
    Positionable(-0.04947704076766968, 1.0, 0.0),
    Positionable(-0.5494770407676697, -0.5, 0.0),
    Positionable(-0.5494770407676697, 0.5, 0.0),
    Positionable(-0.04947700351476669, -0.8660253882408142, 0.5),
    Positionable(-0.04947708547115326, 0.8660253882408142, -0.5),
    Positionable(-0.5494770407676697, -0.4330126941204071, 0.25),
    Positionable(-0.5494770407676697, 0.4330126941204071, -0.25),
    Positionable(-0.04947708547115326, -0.8660253882408142, -0.5),
    Positionable(-0.04947700351476669, 0.8660253882408142, 0.5),
    Positionable(-0.5494770407676697, -0.4330126941204071, -0.25),
    Positionable(-0.5494770407676697, 0.4330126941204071, 0.25)
  ];

  static final List<List<int>> _faces = [
    [3, 0],
    [4, 2],
    [1, 3],
    [1, 4],
    [5, 7],
    [8, 6],
    [9, 11],
    [12, 10],
    [7, 1],
    [1, 8],
    [11, 1],
    [1, 12]
  ];
}
