import 'package:flutter/material.dart';

class TestList extends StatelessWidget {
  final List<String> items;

  const TestList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(items[index]),
        );
      },
    );
  }
}
