import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:make_sense/event.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'connection.dart';

class MakeSense {
  static final MakeSenseInstance sharedInstance = new MakeSenseInstance();
  String sdkVersion = "0.1";
  String sdkName = "flutter";
  static final String VIEW_EVENT_KEY = "[CLY]_view";
}

class MakeSenseInstance {
  String serverURl;
  String appKey;
  bool firstView = true;
  String lastViewState;
  List<Events> eventsObject = new List();
  int lastViewTimeStamp = 0;

  void init(String serverURl, String appKey) {
    this.serverURl = serverURl;
    this.appKey = appKey;
  }

  void initWithPushNotification(
      String serverURl, String appKey, String fcmToken) {
    this.serverURl = serverURl;
    this.appKey = appKey;

    updateFCMToken({
      "name": "milan",
      "firebase_token": fcmToken,
      "cust_id": "${Uuid().v5(Uuid.NAMESPACE_URL, serverURl)}"
    });
  }

  void recordEvent(
      {@required String key, Segmentation segmentation, views, int duration}) {
    views = views == null ? false : views;
    Events events = new Events();
    events.count = 1;
    events.key = key;
    events.segmentation = segmentation;
    events.dow = dateOfWeek();
    events.timestamp = new DateTime.now().millisecondsSinceEpoch;
    events.hour = new DateTime.now().hour;
    print(views);
    if (!views) {
      eventsObject = new List();
    } else {
      eventsObject[0].segmentation.map.remove("visit");
      eventsObject[0].segmentation.map.remove("start");
      eventsObject[0].segmentation.map.addAll({"dur": duration.toString()});
      for (int i = 0; i < eventsObject.length; i++) {
        print(eventsObject[i].toMap());
      }
    }
    eventsObject.add(events);

    Connection()
        .events(serverURl +
            "?events=${eventsToJson(eventsObject)}" +
            defaultRequest())
        .then((onEvents) {
      if (onEvents.statusCode == 200) {
        print("success");
      } else {
        print(onEvents.statusCode);
        print(onEvents.body);
      }
    });
  }

  int dateOfWeek() {
    int day = DateTime.now().weekday;
    return day == 7 ? 0 : day;
  }

  updateFCMToken(Map<String, String> map) {
    Connection()
        .updateToken(
            serverURl + "?user_details=${json.encode(map)}" + defaultRequest())
        .then((onTokenUpdate) {
      if (onTokenUpdate.statusCode == 200) {
        print("success");
      } else {
        print(onTokenUpdate.statusCode);
        print(onTokenUpdate.body);
      }
    });
  }

  recordViews(String pageViewName, [int duration]) {
    firstView
        ? recordEvent(
            key: MakeSense.VIEW_EVENT_KEY,
            segmentation: Segmentation({
              "name": pageViewName,
              "segment": Platform.isAndroid ? "Android" : "iOS",
              "start": "1",
              "visit": "1"
            }),
          )
        : recordEvent(
            key: MakeSense.VIEW_EVENT_KEY,
            segmentation: Segmentation({
              "name": pageViewName,
              "segment": Platform.isAndroid ? "Android" : "iOS",
              "visit": "1"
            }),
            views: true,
            duration: duration);
    if (firstView) {
      firstView = false;
    }
  }

  String defaultRequest() {
    return "&app_key=$appKey&sdk_version=${MakeSense().sdkVersion}&sdk_name=${MakeSense().sdkName}&device_id=${Uuid().v5(Uuid.NAMESPACE_URL, serverURl)}";
  }

  Future<Void> onStart(BuildContext context, String pageName) async {
    String route = /*ModalRoute.of(context).settings.name*/ pageName;
    int duration;
    int currentTimeStamp =
        (new DateTime.now().millisecondsSinceEpoch / 1000).round();
    print(currentTimeStamp);
    print(lastViewTimeStamp);
    if (lastViewState != route) {
      //dur current time stamp - lastViewTimeStamp = duration;
      duration = currentTimeStamp - lastViewTimeStamp;
      print(duration);
    }
    lastViewTimeStamp = currentTimeStamp;

    lastViewState = route;

    print(route);
    recordViews(route, duration);
  }
}
