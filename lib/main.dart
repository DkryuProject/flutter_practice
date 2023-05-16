import 'package:flutter/material.dart';
import 'package:flutter_project/views/todo_list.dart';
import 'views/test_list.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test',
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => TestList(),
        '/todo': (context) => const TodoList(),
      },
    );
  }
}
