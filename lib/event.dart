

import 'dart:convert';

List<Events> eventsFromJson(String str) => List<Events>.from(json.decode(str).map((x) => Events.fromMap(x)));

String eventsToJson(List<Events> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Events {
  String key;
  int count;
  Segmentation segmentation;
  int timestamp;
  int hour;
  int dow;

  Events({
    this.key,
    this.count,
    this.segmentation,
    this.timestamp,
    this.hour,
    this.dow,
  });

  factory Events.fromMap(Map<String, dynamic> json) => Events(
    key: json["key"] == null ? null : json["key"],
    count: json["count"] == null ? null : json["count"],
    timestamp: json["timestamp"] == null ? null : json["timestamp"],
    hour: json["hour"] == null ? null : json["hour"],
    dow: json["dow"] == null ? null : json["dow"],
  );

  Map<String, dynamic> toMap() => {
    "key": key == null ? null : key,
    "count": count == null ? null : count,
    "segmentation": segmentation == null ? null : segmentation.toMap(),
    "timestamp": timestamp == null ? null : timestamp,
    "hour": hour == null ? null : hour,
    "dow": dow == null ? null : dow,
  };
}

class Segmentation {
  Map<String, String> map;


  Segmentation(this. map);


  Map<String, String> toMap() => map;
}