import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Function(RemoteMessage)? onMessageTop;
  final Function(String, String)? onTokenRefresh;
  final String urlLaunchActionId = 'id_1';
  final String navigationActionId = 'id_3';
  final String darwinNotificationCategoryText = 'textCategory';
  final String darwinNotificationCategoryPlain = 'plainCategory';

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  FcmService({this.onMessageTop, this.onTokenRefresh});

  Future initialize() async {
    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
          DarwinNotificationCategory(
            darwinNotificationCategoryText,
            actions: <DarwinNotificationAction>[
              DarwinNotificationAction.text(
                'text_1',
                'Action 1',
                buttonTitle: 'Send',
                placeholder: 'Placeholder',
              ),
            ],
          ),
          DarwinNotificationCategory(
            darwinNotificationCategoryPlain,
            actions: <DarwinNotificationAction>[
              DarwinNotificationAction.plain('id_1', 'Action 1'),
              DarwinNotificationAction.plain(
                'id_2',
                'Action 2 (destructive)',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.destructive,
                },
              ),
              DarwinNotificationAction.plain(
                navigationActionId,
                'Action 3 (foreground)',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.foreground,
                },
              ),
              DarwinNotificationAction.plain(
                'id_4',
                'Action 4 (auth required)',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.authenticationRequired,
                },
              ),
            ],
            options: <DarwinNotificationCategoryOption>{
              DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
            },
          ),
        ];

    // 백그라운드 메시지 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 안드로이드 알림 채널 생성
    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);
    }

    // IOS 포그라운드에서 푸시 알림 처리
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    // 로컬 알림 설정
    await _initializeLocalNotification(darwinNotificationCategories);

    // 메시지 리스너 설정
    _setupMessageListeners();

    // 알림 권한 요청
    await _requestPermissions();

    // 토큰 얻기 및 리스너 설정
    await _getToken();
  }

  // 백그라운드에서 푸시 알림 처리
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    print("백그라운드 메시지 처리: ${message.messageId}");
    // 여기에 푸시 알림을 처리하는 로직을 추가하거나, 상태 유지 로직을 구현합니다.
  }

  Future _initializeLocalNotification(
    List<DarwinNotificationCategory> darwinNotificationCategories,
  ) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          notificationCategories: darwinNotificationCategories,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse reponse) {
        //로컬 알림을 탭했을 때 처리
        print("로컬 알림 탭: ${reponse.payload}");
      },
    );
  }

  void _setupMessageListeners() {
    // 포그라운드 메시지 처리
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("포그라운드 메시지 처리: ${message.messageId}");
      _showLocalNotification(message);
    });

    // 백그라운드 상태에서 알림 탭 처리
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // 앱 종료된 상태에서 알림 탭 처리 (앱 시작 시 확인)
    _checkInitialMessage();
  }

  Future _checkInitialMessage() async {
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void _handleMessage(RemoteMessage message) {
    print("메시지 처리 ${message.messageId}");
    //콜백 호출
    if (onMessageTop != null) {
      onMessageTop!(message);
    }
  }

  // 로컬 알림 표시
  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // 안드로이드에서 포그라운드 알림 표시
    if (notification != null && android != null && Platform.isAndroid) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: android.smallIcon ?? 'launch_background',
            importance: Importance.high,
            priority: Priority.high,
            ticker: notification.title,
            color: Colors.blue,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  // 알림 권한 요청
  Future _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print("사용자 알림 권한 상태 ${settings.authorizationStatus}");
  }

  // FCM 토큰 얻기
  Future _getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");

    // 토큰 갱신 리스너
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print("FCM 토큰 갱신 $newToken");
      if (onTokenRefresh != null) {
        onTokenRefresh!(newToken, token!);
      }
      token = newToken;
    });

    return token;
  }

  // 수동으로 현재 토큰 얻기
  Future getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // 특정 주제 구독
  Future subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print("주제 구독: $topic");
  }

  // 특정 주제 구독 취소
  Future unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print("주제 구독 취소: $topic");
  }
}
