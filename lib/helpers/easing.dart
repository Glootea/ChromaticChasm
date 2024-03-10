import 'dart:math';

typedef EasingFunction = double Function(double);

///Should be applied to normalized(0-1) values, for example - timeFraction
class EasingFunctions {
  static double easeInOutCubic(double n) {
    return n < 0.5 ? 4 * n * n * n : 1 - pow(-2 * n + 2, 3) / 2;
  }

  static double easeInCubic(double n) {
    return 4 * n * n * n;
  }

  static double easeOutCubic(double n) {
    return 1 - pow(1 - n, 3).toDouble();
  }

  static double linear(double n) => n;
}
