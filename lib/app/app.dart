import 'package:flutter/material.dart';
import 'package:mind_manager/navigation/main_navigation.dart';

class MindManager extends StatelessWidget {
  const MindManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MainNavigation.initialRoute,
      routes: MainNavigation.routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
