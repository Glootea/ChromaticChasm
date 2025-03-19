import 'package:chromatic_chasm/game/run_state.dart';
import 'package:test/test.dart';

void main() {
  group('Run state: ', () {
    RunState state = RunState();
    setUp(() {
      state = RunState();
    });
    test('remove life', () {
      state.removeLife();
      assert(state.lives == 2);
    });
    test('remove last life', () {
      state.removeLife();
      state.removeLife();
      state.removeLife();
      assert(state.lives == 0);
      state.removeLife();
      assert(state.lives == 0);
    });
    test('add score', () {
      assert(state.score == 0);
      state.addScore(10);
      assert(state.score == 10);
      state.addScore(15);
      assert(state.score == 25);
    });
  });
}
