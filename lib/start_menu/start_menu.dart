import 'package:chromatic_chasm/game/game_screen.dart';
import 'package:chromatic_chasm/level_builder/level_selector/level_selector_screen.dart';
import 'package:chromatic_chasm/utils.dart';
import 'package:flutter/material.dart';

class StartMenu extends StatelessWidget {
  const StartMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(flex: 6, child: SizedBox()),
            Text(
              context.localization.appTitle,
              style: Theme.of(context).textTheme.headlineLarge,
              maxLines: 2,
            ),
            const Expanded(flex: 2, child: SizedBox()),
            FilledButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  ),
              child: Text(context.localization.play),
            ),
            const Expanded(child: SizedBox()),
            FilledButton(
              onPressed: () {},
              child: Text(context.localization.tutorial),
            ),
            const Expanded(child: SizedBox()),
            FilledButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LevelSelectorScreen(),
                    ),
                  ),
              child: Text(context.localization.levelBuilder),
            ),
            const Expanded(flex: 6, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
