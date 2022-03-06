import 'dart:developer';

import '../../configs/svg_constants.dart';
import '../../modules/adminControl/roomListControl/roomListControlView.dart';
import '../../modules/masterApp/masterAppScreen.dart';
import '../../modules/masterApp/notificationView.dart' as masterApp;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import '../../constants/appColor.dart';
import '../../core/locales/i18nKey.dart';
import '../../core/routes/routeName.dart';
import '../../models/notification/push_notification.dart';
import '../../repositories/notificaiton/notification_res.dart';
import '../../utils/screenUtil.dart';
import '../../widgets/appAppBar.dart';
import '../../widgets/appBotNav.dart';
import '../addMeeting/addMeetingView.dart';
import '../base/baseView.dart';
import '../myMeeting/myMeetingView.dart';
import '../roomMeeting/roomMeetingView.dart';
import '../setting/settingView.dart';
import 'homeModel.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

// const MethodChannel platform =
//     MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

String selectedNotificationPayload;

class HomeView extends StatefulWidget {
  final String module;
  HomeView(this.module);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseMessaging _messaging;
  PushNotification _notificationInfo;
  // int _totalNotifications;
  Future<void> _showNotification({String title, String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title ?? '',
      body ?? '',
      platformChannelSpecifics,
      payload: selectedNotificationPayload,
    );
  }

  void _requestPermissionsLocal() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'].toString(),
          dataBody: message.data['body'].toString(),
        );

        setState(() {
          _notificationInfo = notification;
          // _totalNotifications++;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          /* showSimpleNotification(
            Text(_notificationInfo.title),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo.body),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          ); */
          _showNotification(
            title: _notificationInfo.title,
            body: _notificationInfo.body,
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
    //Get FCM token
    if (widget.module == RouteName.home) {
      _messaging?.getToken()?.then(
        (fcmToken) {
          log('fcmToken: $fcmToken');
          NotificationRes()
              .updateFcmToken(fcmToken)
              .then((value) =>
                  log('Call updateFcmToken to server ${value ? 'Ok' : 'Fail'}'))
              .catchError((e) => log('Call updateFcmToken Error: $e'));
        },
      )?.catchError((dynamic err) {
        log('Has some errors on get fcmToken: $err');
      });
    }
  }

  // For handling notification when the app is in terminated state
  void checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'].toString(),
        dataBody: initialMessage.data['body'].toString(),
      );

      setState(() {
        _notificationInfo = notification;
        // _totalNotifications++;
      });
    }
  }

  @override
  void initState() {
    // _totalNotifications = 0;
    _requestPermissionsLocal();
    registerNotification();
    checkForInitialMessage();
    _initLocalPushNotification();
    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'].toString(),
        dataBody: message.data['body'].toString(),
      );

      setState(() {
        _notificationInfo = notification;
        // _totalNotifications++;
      });
    });

    super.initState();
  }

  _initLocalPushNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification:
                (int id, String title, String body, String payload) async {
              didReceiveLocalNotificationSubject.add(ReceivedNotification(
                  id: id, title: title, body: body, payload: payload));
            });

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
    });
  }

  List<ModuleModel> modules = [
    ModuleModel(
      svgIcon: SvgIcons.smartMeeting,
      title: 'Smart Meeting'.toUpperCase(),
      subTitle: 'Create meeting on your own',
      route: RouteName.smartMeeting,
    ),
    ModuleModel(
      svgIcon: SvgIcons.smartParking,
      title: 'Smart Parking'.toUpperCase(),
      subTitle: 'Find you place faster',
      route: RouteName.smartParking,
    ),
    ModuleModel(
      svgIcon: SvgIcons.faceRecognization,
      title: 'Face Recgnition'.toUpperCase(),
      subTitle: 'Remote control with FaceID',
      route: RouteName.faceRecgnition,
    ),
  ];

  Widget _buildView(HomeModel model) {
    int index = model.currentIndex;
    switch (widget.module) {
      case RouteName.home:
        switch (index) {
          case 0:
            return MasterAppScreen(modules: modules);
          case 1:
            return masterApp.NotificationView();
          case 2:
            return SettingView();
          default:
            return RoomMeetingView();
        }
        break;
      case RouteName.smartMeeting:
        switch (index) {
          case 0:
            return RoomMeetingView();
          case 1:
            return MyMeetingView();
          case 2:
            return AddMeetingView(navigator: () {
              model.navigate(0);
            });
          case 3:
            return model.currentUser.admin
                ? RoomListControlView()
                : Container();
          default:
            return RoomMeetingView();
        }
        break;
      default:
        switch (index) {
          case 0:
            return MasterAppScreen(modules: modules);
          case 1:
            return masterApp.NotificationView();
          case 2:
            return SettingView();
          default:
            return RoomMeetingView();
        }
    }
  }

  List<AppBotNavItem> smartMeetingBotNav = [
    AppBotNavItem(
      iconData: Icons.dashboard,
      title: '${ScreenUtil.t(I18nKey.meetingRoom)}',
    ),
    AppBotNavItem(
      iconData: Icons.person,
      title: '${ScreenUtil.t(I18nKey.myMeeting)}',
    ),
    AppBotNavItem(
      iconData: Icons.add_business_rounded,
      title: '${ScreenUtil.t(I18nKey.orderRoom)}',
    ),
    AppBotNavItem(
      iconData: Icons.bar_chart,
      title: '${ScreenUtil.t(I18nKey.adminControl)}',
    ),
  ];

  List<AppBotNavItem> appMasterBotNav = [
    AppBotNavItem(
      svgIcon: SvgIcons.home,
      title: '${ScreenUtil.t(I18nKey.masterApp)}',
    ),
    AppBotNavItem(
      svgIcon: SvgIcons.notification,
      title: '${ScreenUtil.t(I18nKey.notification)}',
    ),
    AppBotNavItem(
      svgIcon: SvgIcons.setting,
      title: '${ScreenUtil.t(I18nKey.setting)}',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    List<AppBotNavItem> botNavItems = [];
    switch (widget.module) {
      case RouteName.home:
        botNavItems = appMasterBotNav;
        break;
      case RouteName.smartMeeting:
        botNavItems = smartMeetingBotNav;
        break;
    }
    String initTitle;
    switch (widget.module) {
      case RouteName.home:
        initTitle = I18nKey.masterApp;
        break;
      case RouteName.smartMeeting:
        initTitle = I18nKey.meetingRoom;
        break;
    }
    bool isMasterApp = widget.module == RouteName.home;

    return BaseView<HomeModel>(
        model: HomeModel(widget.module),
        onModelReady: (model) async {
          await model.init();
        },
        builder: (context, model, _) {
          final title = model.currentTitle ?? initTitle;
          final isAdmin = model.currentUser?.admin;
          if (isAdmin != null && !isAdmin && !isMasterApp) {
            botNavItems.removeWhere(
              (e) => e.title == '${ScreenUtil.t(I18nKey.adminControl)}',
            );
          }
          return Scaffold(
            appBar: AppAppBar(
              allowBack: !isMasterApp,
              centerTitle: isMasterApp ? model.currentIndex != 0 : true,
              title: '${ScreenUtil.t(title)}',
            ),
            bottomNavigationBar: AppBotNav(
              modelIndex: model.currentIndex,
              color: AppColor.white,
              backgroundColor: AppColor.primary,
              selectedColor: AppColor.primary,
              notchedShape: CircularNotchedRectangle(),
              onTabSelected: (index) {
                model.navigate(index);
              },
              items: botNavItems,
            ),
            body: _buildView(model),
          );
        });
  }
}
