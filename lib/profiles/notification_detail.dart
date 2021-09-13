import 'dart:ui';

import 'package:flutter/material.dart';

class NotificationDetail extends StatelessWidget {
  final int notificationBanner;
  final int approvalStatus;
  final String getDays;
  final String totalSpent;
  final String retailerName;
  final TextSpan getAcceptedOrRejectedtext;
  NotificationDetail(
      {this.notificationBanner,
      this.approvalStatus,
      this.getDays,
      this.totalSpent,
      this.retailerName,
      this.getAcceptedOrRejectedtext});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget acceptedOrRejected({String totalSpent}) {
      if (approvalStatus == 1)
        return Text(
            'Your \$$totalSpent has been rejected. Please contact iBuy suppport team.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red[700]));
      else
        return Text('Your \$$totalSpent has been approved',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Detail'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all()),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Text(
                  'Retailer: $retailerName',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text('Notified $getDays'),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text('Amount that you spend at $retailerName is \$$totalSpent'),
                acceptedOrRejected(totalSpent: totalSpent),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
