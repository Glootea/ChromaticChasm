import 'dart:async';
import 'dart:io';

import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/share/level_conterter.dart';
import 'package:chromatic_chasm/share/platform_share/common_share.dart';
import 'package:chromatic_chasm/share/url_shortener.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ShareProvider {
  bool get isShareSupported => kIsWeb || Platform.isMacOS || Platform.isAndroid;

  /// Returns (new url, has error)
  FutureOr<(String, bool)> getLevelLink(Level level, bool shorten) async {
    final levelData = LevelConverter.toLink(level);
    if (shorten) {
      try {
        final shortUrl = await UrlShortener.shorten(levelData);
        return (shortUrl, false);
      } catch (e) {
        debugPrint('Failed to shorten url: $e');
        return (levelData, true);
      }
    }
    return (levelData, false);
  }

  /// Returns true if has error shortening url
  Future<bool> onCopyToClipboard({
    required Level level,
    required bool shorten,
  }) async {
    final (levelLink, hasError) = await getLevelLink(level, shorten);
    Clipboard.setData(ClipboardData(text: levelLink));
    return hasError;
  }

  /// Only awailabled on android/windows(not yet implemented), macos and web, on other platforms does nothing
  /// Returns true if has error shortening url
  Future<bool> onSystemShare({
    // TODO: implement on android
    required Level level,
    required bool shorten,
  }) async {
    assert(isShareSupported);
    final (levelLink, hasError) = await getLevelLink(level, shorten);
    shareLink(levelLink);
    return hasError;
  }
}
