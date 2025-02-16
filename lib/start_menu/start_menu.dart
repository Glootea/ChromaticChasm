import 'package:chromatic_chasm/database/database.dart';
import 'package:chromatic_chasm/game/game_screen/game_screen.dart';
import 'package:chromatic_chasm/game/level_provider.dart';
import 'package:chromatic_chasm/level_builder/level_selector/level_selector_screen.dart';
import 'package:chromatic_chasm/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartMenu extends StatelessWidget {
  final ChromaticChasmDatabase database;
  const StartMenu({required this.database, super.key});

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
              onPressed: () async {
                final levelProvider = await LevelProvider.create(database);
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return GameScreen(levelProvider: levelProvider);
                      },
                    ),
                  );
                }
              },
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
                      builder:
                          (context) => Provider.value(
                            value: database,
                            child: const LevelSelectorScreen(),
                          ),
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
