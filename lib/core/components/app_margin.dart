import 'package:flutter/material.dart';

class AppMargin extends StatelessWidget {
  final Widget child;

  const AppMargin({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: child);
  }
}
