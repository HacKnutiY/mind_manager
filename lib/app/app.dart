import 'package:flutter/material.dart';
import 'package:mind_manager/features/activities/views/activities_screen.dart';
import 'package:mind_manager/features/focus/focus.dart';
import 'package:mind_manager/features/sprint/views/sprints_screen.dart';
import 'package:mind_manager/features/tasks/tasks.dart';
import 'package:mind_manager/navigation/main_navigation.dart';

class MindManager extends StatefulWidget {
  const MindManager({super.key});

  @override
  State<MindManager> createState() => _MindManagerState();
}

class _MindManagerState extends State<MindManager> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: MainNavigation.initialRoute,
      routes: MainNavigation.routes,
      onGenerateRoute: onGenerateRoute,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTabIndex = 0;

  List<Widget> tabs = [
    ActivitiesScreen(),
    SprintsScreen(),
    const TasksScreen(),
    const FocusScreen(),
  ];

  List<String> tabNames = ["Направления", "Спринты", "Задачи", "Фокус"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // важно для 4+ табов
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Направления',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Спринты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Фокус',
          ),
        ],
      ),
    );
  }
}
