import 'package:chromatic_chasm/game/run_state.dart';
import 'package:test/test.dart';

void main() {
  group('Run state:', () {
    RunState state = RunState();
    setUp(() {
      state = RunState();
    });
    test('remove life', () {
      assert(state.lives == 3, 'Must start with 3 lives');
      state.removeLife();
      assert(state.lives == 2, 'After removing one life there must be 2 lifes');
    });
    test('remove last life', () {
      state.removeLife();
      state.removeLife();
      state.removeLife();
      assert(
        state.lives == 0,
        'After removing three lifes there must be 0 lifes',
      );
      state.removeLife();
      assert(state.lives == 0, 'Lives cant go below zero');
    });
    test('add score', () {
      assert(state.score == 0, 'Must start with zero points');
      state.addScore(10);
      assert(state.score == 10, 'Score must be 10');
      state.addScore(15);
      assert(state.score == 25, 'Score must be 10+15=25');
    });
  });
}
