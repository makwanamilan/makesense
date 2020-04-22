library make_sense;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:make_sense/connection.dart';
import 'package:make_sense/event.dart';
import 'package:uuid/uuid.dart';



class MakeSense {
  static final MakeSenseInstance sharedInstance = new MakeSenseInstance();
  String sdkVersion = "0.1";
  String sdkName = "flutter";
  static final String VIEW_EVENT_KEY = "[CLY]_view";
}

class MakeSenseInstance {
  String serverURl;
  String appKey;
  bool firstView = false;
  String lastViewState;

  void init(String serverURl, String appKey) {
    this.serverURl = serverURl;
    this.appKey = appKey;
  }
  void initWithPushNotification(String serverURl, String appKey, String fcmToken) {
    this.serverURl = serverURl;
    this.appKey = appKey;
    updateFCMToken(fcmToken);

  }
  void recordEvent(String key, [Segmentation segmentation]) {
    Events events = new Events();
    events.count = 1;
    events.key = key;
    events.segmentation = segmentation;
    events.dow=dateOfWeek();
    events.timestamp = new DateTime.now().millisecondsSinceEpoch;
    events.hour = new DateTime.now().hour;
    List<Events> eventsObject = new List();
    eventsObject.add(events);

    Connection()
        .events(serverURl +
        "?events=${eventsToJson(eventsObject)}"+defaultRequest())
        .then((onEvents) {
      if (onEvents.statusCode == 200) {
        print("success");
      } else {
        print(onEvents.statusCode);
        print(onEvents.body);
      }
    });
  }

  int dateOfWeek(){
    int day = DateTime.now().weekday;
    return day==7?0:day;
  }

  updateFCMToken(token){
    Connection().updateToken(serverURl+"?token_session=1&test_mode=1&android_token=$token"+defaultRequest()).then((onTokenUpdate){
      if (onTokenUpdate.statusCode == 200) {
        print("success");
      } else {
        print(onTokenUpdate.statusCode);
        print(onTokenUpdate.body);
      }
    });
  }

  recordViews(String pageViewName)
  {
    if(firstView){
      firstView= false;
    }
    recordEvent(MakeSense.VIEW_EVENT_KEY,firstView?Segmentation(
        {
          "name":pageViewName,
          "visit":"1",
          "segment":Platform.isAndroid?"Android":"iOS",
          "start": "1",
        }):Segmentation(
        {
          "name":pageViewName,
          "visit":"1",
          "segment":Platform.isAndroid?"Android":"iOS",
          "start": "1",
        }));
  }
  String defaultRequest(){
    return "&app_key=$appKey&sdk_version=${MakeSense().sdkVersion}&sdk_name=${MakeSense().sdkName}&device_id=${Uuid().v5(Uuid.NAMESPACE_URL, serverURl)}";
  }

  Future<void> onStart(BuildContext context) async{
    String route = ModalRoute.of(context).settings.name;

    if(lastViewState != route){
      //dur current time stamp - lastViewTimeStamp = duration;
    }
    lastViewState = route;

    print(route);
    recordViews(route);
  }
}
