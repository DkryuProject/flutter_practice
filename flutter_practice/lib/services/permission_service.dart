import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> checkContactsPermission() async {
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

  static Future<void> requestContactsPermission() async {
    var result = await Permission.contacts.request();
    print("연락처 권한 요청 결과: $result");

    if (result.isGranted) {
      print("연락처 권한이 허용되었습니다.");
    } else {
      print("연락처 권한이 거부되었습니다.");
    }
  }
}
