import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

void main() {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '40686b26446e6d38140f3ed9ba43c08a',
    javaScriptAppKey: 'f66bf8f0756abc2844d70860cbbbd8e9',
  );
  runApp(KakaoTest());
}

class KakaoTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('카카오 테스트')),
        body: Container(),
      ),
    );
  }
}
