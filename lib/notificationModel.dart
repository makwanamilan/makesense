// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  Notification notification;
  Data data;

  NotificationModel({
    this.notification,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    notification: json["notification"] == null ? null : Notification.fromJson(json["notification"]),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "notification": notification == null ? null : notification.toJson(),
    "data": data == null ? null : data.toJson(),
  };
}
Data DataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  String dlUrl;
  String imageUrl;
  String redirectNotiPg;

  Data({
    this.dlUrl,
    this.imageUrl,
    this.redirectNotiPg,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    dlUrl: json["dl_url"] == null ? null : json["dl_url"],
    imageUrl: json["image_url"] == null ? null : json["image_url"],
    redirectNotiPg: json["redirect_noti_pg"] == null ? null : json["redirect_noti_pg"],
  );

  Map<String, dynamic> toJson() => {
    "dl_url": dlUrl == null ? null : dlUrl,
    "image_url": imageUrl == null ? null : imageUrl,
    "redirectNotiPg": redirectNotiPg == null ? null : redirectNotiPg,
  };
}

class Notification {
  String body;
  String title;

  Notification({
    this.body,
    this.title,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    body: json["body"] == null ? null : json["body"],
    title: json["title"] == null ? null : json["title"],
  );

  Map<String, dynamic> toJson() => {
    "body": body == null ? null : body,
    "title": title == null ? null : title,
  };
}
