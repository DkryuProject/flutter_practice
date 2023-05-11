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
          title: null,
        ),
        body: const TestList(items: [
          '저장 테스트',
          '달력 테스트',
          '알리 테스트'
        ]),
      ),
    );
  }
}
