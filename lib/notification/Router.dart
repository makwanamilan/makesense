import 'package:flutter/material.dart';
import 'package:make_sense/notification/notificationModel.dart';

class Router {
  internalRouter(Data data ,BuildContext context) {
    var urlData = data.dlUrl.split("/");
    var notificationPage = data.redirectNotiPg;

    if (notificationPage == "false") {
      String module = urlData[urlData.length - 2];
      String id = urlData[urlData.length - 1];

//      switch (module) {
//        case "offer":
//          if (id == "null") {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => OfferPage()),
//            );
//          } else {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => OfferDetailPage(id)),
//            );
//          }
//          break;
//        case "flight":
//          if (id == "null") {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => OfferPage()),
//            );
//          } else {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => OfferDetailPage(id)),
//            );
//          }
//          break;
//      }
    }else{
//      Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => NotificationPage()),
//      );
    }
  }
}
