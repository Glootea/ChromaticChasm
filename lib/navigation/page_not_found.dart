import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  final String path;
  const PageNotFound({required this.path, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Page not found: $path')),
    ); // TODO: translate
  }
}
