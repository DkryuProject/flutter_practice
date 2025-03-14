import 'package:flutter/material.dart';

class TestList extends StatelessWidget {
  final List<String> items = ['file', 'kakao', 'contract'];

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
                  if (selectedItem == 'file') {
                    Navigator.pushNamed(context, '/file');
                  } else if (selectedItem == 'contract') {
                    Navigator.pushNamed(context, '/contract');
                  } else if (selectedItem == 'kakao') {
                    Navigator.pushNamed(context, '/kakao');
                  }
                },
              ),
            );
          },
        ));
  }
}
