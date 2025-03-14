import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(ContractTest());
}

class ContractTest extends StatefulWidget {
  @override
  _ContractTestState createState() => _ContractTestState();
}

class _ContractTestState extends State<ContractTest> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      Iterable<Contact> _contacts = await ContactsService.getContacts();
      setState(() {
        contacts = _contacts.toList();
      });
    } else {
      print("연락처 권한이 거부되었습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('연락처 목록')),
        body: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(contacts[index].displayName ?? '이름 없음'),
              subtitle: contacts[index].phones!.isNotEmpty
                  ? Text(contacts[index].phones!.first.value ?? '')
                  : Text('전화번호 없음'),
            );
          },
        ),
      ),
    );
  }
}
