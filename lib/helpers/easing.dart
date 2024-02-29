import 'dart:math';

extension Easing on double {
  double get easeInOutCubic {
    return this < 0.5 ? 4 * this * this * this : 1 - pow(-2 * this + 2, 3) / 2;
  }
}
