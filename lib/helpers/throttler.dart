import 'dart:async';

class Throttler {
  final Duration delay;

  Timer? _timer;
  bool _isThrottling = false;

  Throttler(this.delay);

  void throttle(Function action) {
    if (!_isThrottling) {
      action();
      _isThrottling = true;
      _timer = Timer(delay, () => _isThrottling = false);
    }
  }

  void dispose() => _timer?.cancel();
}
