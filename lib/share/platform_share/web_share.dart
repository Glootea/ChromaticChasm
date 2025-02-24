import 'dart:js_interop';

Future<void> shareLink(String url) async {
  shareLinkJS(url);
}

@JS('shareLink')
external void shareLinkJS(String url, [String? title, String? text]);
