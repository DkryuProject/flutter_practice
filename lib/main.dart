import 'package:flutter/material.dart';
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Test Page'),
        ),
        body: const TestList(items: ['Item 1', 'Item 2', 'Item 3']),
      ),
    );
  }
}
