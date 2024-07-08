import 'package:flutter/material.dart';
import 'package:sat_app/pages/base_page.dart';
import 'package:sat_app/pages/home_page.dart';
import 'package:sat_app/pages/question_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 97, 184, 255)),
        useMaterial3: true,
      ),
      home: BasePage(),
    );
  }
}
