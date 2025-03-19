import 'package:flutter/material.dart';

import 'address_book_page.dart';
import 'contract_page.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final List<String> items = ["도로명 주소 테스트", "연락처 테스트", "푸스 테스트"];

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            onTap: () {
              if (items[index] == '도로명 주소 테스트') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressBookPage(),
                  ),
                );
              } else if (items[index] == '연락처 테스트') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContractTest()),
                );
              }
            },
          );
        },
      ),
    );
  }
}
