import 'dart:async';
import 'dart:io' show Platform;
// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/auth_service.dart';
import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/config/routes.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/firebase_options.dart';
import 'package:jara_market/send_token_service.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'dart:developer' as myLog;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'screens/splash/splash_screen.dart';
// 'https://github.com/DANIEL-EKWERE/jara-customer.git/'

// ─── Globals ────────────────────────────────────────────────────────────────

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final StreamController<NotificationResponse> selectNotificationStream =
    StreamController<NotificationResponse>.broadcast();

const MethodChannel platform = MethodChannel(
  'dexterx.dev/flutter_local_notifications_example',
);

String? selectedNotificationPayload;

const String urlLaunchActionId = 'id_1';
const String navigationActionId = 'id_3';
const String darwinNotificationCategoryText = 'textCategory';
const String darwinNotificationCategoryPlain = 'plainCategory';

// ─── Background notification tap handler (must be top-level) ────────────────

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  myLog.log('Notification tapped in background: ${notificationResponse.id}');
}

// ─── FCM background handler (must be top-level) ─────────────────────────────

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  myLog.log('Handling a background message: ${message.messageId}');

  final FlutterLocalNotificationsPlugin bgPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await bgPlugin.initialize(
    settings: initializationSettings, // named param (v20+)
    onDidReceiveNotificationResponse: selectNotificationStream.add,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  if (message.notification != null) {
    final notification = message.notification!;
    final android = message.notification?.android;

    if (android != null) {
      await bgPlugin.show(
        id: notification.hashCode, // named param (v20+)
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          // renamed param (v20+)
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
            ticker: 'ticker',
          ),
        ),
      );
    }
  }
}

// ─── FCM foreground message handler (must be top-level) ─────────────────────

void _handleForegroundMessage(RemoteMessage message) {
  myLog.log('Received a foreground message!');
  myLog.log('Message data: ${message.data}');

  if (message.notification != null) {
    myLog.log('Notification: ${message.notification}');

    final notification = message.notification!;
    final android = message.notification?.android;

    if (android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        id: notification.hashCode, // named param (v20+)
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          // renamed param (v20+)
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            ticker: 'ticker',
          ),
        ),
      );
    }
  }
}

// ─── Local notifications init (fast, in-process — must run before runApp) ───

Future<void> _initLocalNotifications() async {
  final List<DarwinNotificationCategory> darwinNotificationCategories = [
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: [
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
      actions: [
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: {DarwinNotificationActionOption.destructive},
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: {DarwinNotificationActionOption.foreground},
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: {DarwinNotificationActionOption.authenticationRequired},
        ),
      ],
      options: {DarwinNotificationCategoryOption.hiddenPreviewShowTitle},
    ),
  ];

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // DarwinInitializationSettings replaces the deprecated IOSInitializationSettings
  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    notificationCategories: darwinNotificationCategories,
  );

  final DarwinInitializationSettings initializationSettingsMacOS =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    notificationCategories: darwinNotificationCategories,
  );

  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(
    defaultActionName: 'Open notification',
    defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS,
    linux: initializationSettingsLinux,
  );

  // initialize() now uses named `settings:` parameter (breaking change v20+)
  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: selectNotificationStream.add,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
}

// ─── FCM background setup (runs after runApp, never blocks UI) ───────────────

Future<void> _setupFcmInBackground(SendTokenService sendTokenService) async {
  try {
    final fcm = FirebaseMessaging.instance;

    // Handle notification that launched the app from terminated state
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      myLog.log(
        'App launched from terminated state: ${initialMessage.messageId}',
      );
    }

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(
      (msg) => myLog.log('Message clicked!: $msg'),
    );
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      myLog.log('FCM Token refreshed: $newToken');
      sendTokenService.registerToken(newToken, null, null);
    });

    // Request permission — shows iOS dialog, then fetch token.
    // Both are network calls that can be slow; they must never block runApp().
    final NotificationSettings notificationSettings =
        await fcm.requestPermission(alert: true, badge: true, sound: true);

    if (notificationSettings.authorizationStatus ==
            AuthorizationStatus.authorized ||
        notificationSettings.authorizationStatus ==
            AuthorizationStatus.provisional) {
      myLog.log(
        'Notification permission: ${notificationSettings.authorizationStatus}',
      );
      String? token;
      if (!kIsWeb && Platform.isIOS && await fcm.getAPNSToken() == null) {
        myLog.log(
          'APNS token is not set yet (expected on iOS Simulator or if remote notification registration is pending). Skipping initial FCM token fetch.',
        );
      } else {
        token = await fcm
            .getToken()
            .timeout(const Duration(seconds: 20), onTimeout: () => null);
      }
      if (token != null) {
        myLog.log('FCM Token: $token');
        sendTokenService.registerToken(token, null, null);
      }
    } else {
      myLog.log('Notification permission denied');
    }
  } catch (e) {
    myLog.log('FCM setup error: $e');
  }
}

void main() async {
  // Ensure Flutter framework binding is ready before calling asynchronous code
  WidgetsFlutterBinding.ensureInitialized();

  // Inject the AuthController globally
  Get.put(AuthController());
  Get.put(DataBase());
  Get.put(CartController());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Local notifications plugin init (fast, in-process — needed before any show())
  await _initLocalNotifications();

  final SendTokenService sendTokenService = Get.put(SendTokenService());

  // ── Desktop SQLite init ──────────────────────────────────────────────────

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // ── App init ─────────────────────────────────────────────────────────────

  Get.put(DataBase());

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  DataBase dataBase = Get.put(DataBase());
  var token = await dataBase.getToken();
  String initialRoute = token.isNotEmpty ? '/main_screen' : '/splash_screen';
  runApp(MyApp(initialRoute: initialRoute));

  // FCM permission + token run in the background after runApp fires.
  // They must never block runApp — they make network/dialog calls that can hang.
  unawaited(_setupFcmInBackground(sendTokenService));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);
  final String initialRoute;
  @override
  Widget build(BuildContext context) {
    return OverlayKit(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auth App',
        theme: ThemeData(
          primaryColor: const Color(0xFFFFAA00),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Roboto',
          //fontFamilyFallback: ['Roboto'],
        ),
        // home: const SplashScreen(),
        initialRoute: initialRoute,
        getPages: AppRoutes.pages,
      ),
    );
  }
}
