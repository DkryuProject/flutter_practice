import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class ContractTest extends StatefulWidget {
  const ContractTest({super.key});

  @override
  State<ContractTest> createState() => _ContractTestState();
}

class _ContractTestState extends State<ContractTest> {
  final TextEditingController _phoneNumberController = TextEditingController();

  // 연락처 선택 후 돌아오면 실행되는 함수
  Future<void> _pickContact() async {
    final String? selectedPhoneNumber = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactListScreen()),
    );

    if (selectedPhoneNumber != null) {
      setState(() {
        _phoneNumberController.text = selectedPhoneNumber;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("연락처 선택 예제")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: "연락처 번호",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (!kIsWeb)
              ElevatedButton(
                onPressed: _pickContact,
                child: Text("연락처에서 선택"),
              ),
          ],
        ),
      ),
    );
  }
}

// 연락처 목록 페이지
class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  // 연락처 가져오기
  Future<void> _loadContacts() async {
    PermissionStatus status = await Permission.contacts.request();

    if (status.isGranted) {
      Iterable<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      setState(() {
        _contacts = contacts.toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("연락처 접근 권한이 필요합니다.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("연락처 목록")),
      body: _contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                Contact contact = _contacts[index];
                String userName = contact.displayName ?? "이름 없음";
                String phoneNumber = contact.phones?.isNotEmpty == true
                    ? contact.phones!.first.value ?? ""
                    : "";

                return ListTile(
                  title: Text(userName),
                  subtitle: Text(phoneNumber),
                  onTap: () {
                    Navigator.pop(context, phoneNumber); // 선택된 연락처 번호 반환
                  },
                );
              },
            ),
    );
  }
}
