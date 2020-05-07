
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:make_sense/make_sense.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationHandler {

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  showNotificationTextNotification(
      Map<String, dynamic> msg,
      data
      ) async {
//    final iconPath = await saveImage(context, Image.asset('images/gems_logo_.png'));

    var android = new AndroidNotificationDetails(
      'chanel_id',
      "CHANNLE NAME",
      "channelDescription",
      styleInformation: BigTextStyleInformation(msg["notification"]["body"]),
      importance: Importance.Max,
      priority: Priority.High,
//      largeIcon: iconPath,
//      largeIconBitmapSource: BitmapSource.FilePath,
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await MakeSense.sharedInstance.flutterLocalNotificationsPlugin.show(
      0,
      msg["notification"]["title"],
      msg["notification"]["body"],
      platform,
      payload: data,
    );
    // Default_Sound
  }

  showNotificationImageNotification(
      Map<String, dynamic> msg,
      data,String iconPath) async {
    final picturePath =  await _downloadAndSaveFile(msg["data"]["image_url"], "notification");
//    final iconPathImage = await  _downloadAndSaveFile( "http://via.placeholder.com/48x48","iconPath");

    final bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(picturePath),
//      largeIcon: FilePathAndroidBitmap(picturePath),

    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      'big text channel description',
      importance: Importance.Max,
      priority: Priority.High,
//      largeIcon: DrawableResourceAndroidBitmap(picturePath),
      styleInformation: bigPictureStyleInformation,
    );
    var platform = new NotificationDetails(androidPlatformChannelSpecifics, null);
    await MakeSense.sharedInstance.flutterLocalNotificationsPlugin.show(
      0,
      msg["notification"]["title"],
      msg["notification"]["body"],
      platform,
      payload: data,
    );
  }


}
