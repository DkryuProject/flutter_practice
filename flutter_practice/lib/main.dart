import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/pages/list_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkContactsPermission();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

Future<void> checkContactsPermission() async {
  var status = await Permission.contacts.status;
  print("현재 연락처 권한 상태: $status");

  if (status.isDenied) {
    print("연락처 권한이 '거부됨' 상태입니다. 요청을 시도합니다.");
    await requestContactsPermission();
  } else if (status.isPermanentlyDenied) {
    print("연락처 권한이 '영구 거부됨' 상태입니다. 앱 설정 화면으로 유도해야 합니다.");
    openAppSettings();
  } else if (status.isGranted) {
    print("연락처 권한이 이미 허용됨");
  }
}

Future<void> requestContactsPermission() async {
  var result = await Permission.contacts.request();
  print("연락처 권한 요청 결과: $result");

  if (result.isGranted) {
    print("연락처 권한이 허용되었습니다.");
  } else {
    print("연락처 권한이 거부되었습니다.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ListPage(title: 'Flutter Test'),
    );
  }
}
