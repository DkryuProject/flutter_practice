import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'managers/todo.dart';
import 'views/todo_list.dart';
import 'views/test_list.dart';

void main() {
  runApp(
    ChangeNotifierProvider<TodoManager>(
      create: (_) => TodoManager(),
      child: const TestApp(),
    ),
  );
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
