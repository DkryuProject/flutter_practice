import 'package:flutter/material.dart';

class TestList extends StatelessWidget {
  final List<String> items;

  const TestList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(items[index]),
            subtitle: Text('Item $index subtitle'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('You clicked on Item $index'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
