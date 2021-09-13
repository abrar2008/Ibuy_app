//import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:ibuy_mac_1/profiles/receipts_view.dart';
import 'package:ibuy_mac_1/profiles/help.dart';
import 'package:ibuy_mac_1/profiles/notifications.dart';
import 'package:ibuy_mac_1/profiles/order_cashback.dart';
import 'package:ibuy_mac_1/profiles/plan_history.dart';
import 'package:ibuy_mac_1/profiles/setting.dart';
import 'package:ibuy_mac_1/profiles/receipts_view.dart';
import 'package:ibuy_mac_1/profiles/user_profile_view.dart';
import 'package:ibuy_mac_1/camera/image_capture.dart';

class MenuPages extends StatefulWidget {
  final int menuIndex;
  final String pageTitle;

  MenuPages({Key key, @required this.menuIndex, this.pageTitle}) :super(key: key);

  @override
  _MenuPagesState createState() => _MenuPagesState();
}

class _MenuPagesState extends State<MenuPages> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    UserProfileView(),
    OrderCashback(),
    ReceiptsView(),
    PlanHistory(),
    Notifications(),
    Help(),
    Settings()
  ];

  @override
  Widget build(BuildContext context) {
    _currentIndex = widget.menuIndex;
    return Scaffold(
      appBar: AppBar(title: Text(widget.pageTitle)),
      body: _children[_currentIndex],
    );
  }

}
