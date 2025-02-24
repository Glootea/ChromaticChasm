import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

Future<void> shareLink(String url) async {
  const platform = MethodChannel('com.glootea.chromaticChasm/share');

  try {
    await platform.invokeMethod<bool>('shareLevel', {'link': url});
  } catch (e) {
    debugPrint('Error sharing level link: $e');
  }
}
