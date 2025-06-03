import 'package:flutter/material.dart';
import 'AppDrawer.dart';
import 'CustomAppBar.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget child;

  const BasePage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      drawer: const AppDrawer(),
      body: child,
    );
  }
}
