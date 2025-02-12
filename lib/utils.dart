import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localization.dart';

extension Localization on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;
}
