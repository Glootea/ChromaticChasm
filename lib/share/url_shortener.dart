import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class UrlShortener {
  static Future<String> shorten(String url) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://spoo.me/',

        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
        data: {'url': url},
      );
      return response.data['short_url'];
    } catch (e) {
      debugPrint('Failed to shorten url: $e');
      return url;
    }
  }
}
