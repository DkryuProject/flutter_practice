import 'package:flutter/material.dart';

class TestList extends StatelessWidget {
  final List<String> items = ['할일', '달력 테스트', '알림 테스트'];

  TestList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Test List'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(items[index]),
              onTap: () {
                String selectedItem = items[index];
                if (selectedItem == '할일') {
                  Navigator.pushNamed(context, '/todo');
                }
              },
            ),
          );
        },
      )
    );
  }
}
