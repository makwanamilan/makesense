
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationHandler {
  downloadAndSaveImage(String url, String name) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$name';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
  Future<String> saveImage(BuildContext context, Image image) {
    final completer = Completer<String>();

    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((imageInfo, _) async {
      final byteData =
      await imageInfo.image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData.buffer.asUint8List();

      final fileName = pngBytes.hashCode;
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      completer.complete(filePath);
    }));

    return completer.future;
  }
  showNotificationTextNotification(
      Map<String, dynamic> msg,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      data, BuildContext context
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
    await flutterLocalNotificationsPlugin.show(
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
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      data, BuildContext context,String logoSmall) async {
    final picturePath = await downloadAndSaveImage(msg["data"]["image_url"], "notification");
    final iconPath = await saveImage(context, Image.asset(logoSmall));

    final bigPictureStyleInformation = BigPictureStyleInformation(
      picturePath

    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      'big text channel description',
      importance: Importance.Max,
      priority: Priority.High,
      largeIcon: DrawableResourceAndroidBitmap(iconPath),
      styleInformation: bigPictureStyleInformation,
    );
    var platform = new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
      0,
      msg["notification"]["title"],
      msg["notification"]["body"],
      platform,
      payload: data,
    );
  }


}
