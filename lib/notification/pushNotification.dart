import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_sense/notification/Router.dart';
import 'notificationModel.dart';

NotificationModel notificationModel;

Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) {

  print("_backgroundMessageHandler");
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("_backgroundMessageHandler data: ${data}");
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    print("onMessage: $message");
    String str = json.encode(message);

    notificationModel = notificationModelFromJson(str);
    final dynamic notification = message['notification'];
    print("_backgroundMessageHandler notification: ${notification}");
  }
}
class PushNotification extends StatefulWidget {
  @override
  _PushNotificationState createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  // TODO: implement context
  BuildContext get context => super.context;
  AppLifecycleState _notification;
  var mehtodcalled;
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        mehtodcalled = "onMessage";
        String str = json.encode(message);

         notificationModel = notificationModelFromJson(str);
        if (message.containsKey('notification')) {
//          print("dataofvalue ${notificationModel.toString()}");
          showNotification(notificationModel.notification.title,
              notificationModel.notification.body, str);
        }
      },
      onBackgroundMessage: _backgroundMessageHandler,

      onLaunch: (Map<String, dynamic> message) async {
        mehtodcalled = "onLaunch";

        print("onLaunch: $message");
        String str = json.encode(message);
        notificationModel = notificationModelFromJson(str);
        onSelectNotification(str);

        },
      onResume: (Map<String, dynamic> message) async {
//        _navigateToItemDetail(message);
        mehtodcalled = "onResume";

        print("onMessage: $message");
        String str = json.encode(message);

        notificationModel = notificationModelFromJson(str);
              if (message.containsKey('notification')) {
//          print("dataofvalue ${notificationModel.toString()}");
                showNotification(notificationModel.notification.title,
                    notificationModel.notification.body, str);
              }

          print("dataofvalue ${notificationModel.toString()}");
          showNotification(notificationModel.notification.title,
              notificationModel.notification.body, str);
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        print("Push Messaging token: $token");
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Local Notification'),
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            new RaisedButton(
              onPressed: () {},
              child: new Text(
                mehtodcalled!=null?mehtodcalled:"tesed",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            new RaisedButton(
              onPressed: () {},
              child: new Text(
                notificationModel!=null?notificationModel.data.dlUrl:'test',
                style: Theme.of(context).textTheme.headline,
              ),
            ),
          ],
        ),
      ),
    );

  }

  Future onSelectNotification(String payload) {


    NotificationModel notificationModel = notificationModelFromJson(payload);

    Router().internalRouter(notificationModel.data,context);
  }

  showNotification(title, body, data) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, title, body, platform,
        payload: data);
  }
}
