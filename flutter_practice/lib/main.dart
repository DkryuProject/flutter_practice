import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/pages/list_page.dart';
import 'services/firebase_service.dart';
import 'services/fcm_service.dart';
import 'services/permission_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await PermissionService.checkContactsPermission();
  }

  await FirebaseService.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FcmService _fcmService;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _initializeFCM();
    }
  }

  Future _initializeFCM() async {
    _fcmService = FcmService(
      onMessageTop: (message) {
        print("메시지 탭 처리: ${message.data}");
        if (message.data["screen"] == "detail") {
          //해당 스크린으로 이동하는 로직 필요
        }
      },
      onTokenRefresh: (newToken, oldToljen) {
        // 토큰 갱신 시 서버에 업데이트
        _updateTokenOnServer(newToken);
      },
    );

    await _fcmService.initialize();

    // 초기 토큰 얻기
    String? token = await _fcmService.getToken();
    if (token != null) {
      _updateTokenOnServer(token);
    }

    // 특정 주제 구독 (예: 모든 사용자에게 보내는 공지 사항)
    await _fcmService.subscribeToTopic('announcements');

    // 사용자별 맞춤 주제 구독
    //if(isLoggedIn)
    //  await _fcmService.subscribeToTopic('user_${userId}');
  }

  void _updateTokenOnServer(String? token) {
    print("서버에 토큰 업데이트: $token");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ListPage(title: 'Flutter Test'),
    );
  }
}
