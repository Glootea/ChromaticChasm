import 'package:chromatic_chasm/database/database.dart';
import 'package:chromatic_chasm/level_builder/level_selector/level_selector_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
        brightness: Brightness.dark,
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en'), const Locale('ru')],
      locale: const Locale('ru'),
      home: Provider(
        create: (_) => ChromaticChasmDatabase(),
        child: const LevelSelectorScreen(),
      ),
    ),
  );
}
