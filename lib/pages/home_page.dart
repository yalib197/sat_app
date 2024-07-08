import 'package:flutter/material.dart';
import 'package:sat_app/pages/practice_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _pages = [HomePage(), PracticePage()];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prepare for exams!"),
      ),
      body: Text('home page'),
    );
  }
}
