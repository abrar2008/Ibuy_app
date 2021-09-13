import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ibuy_mac_1/models/user_plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ibuy_mac_1/views/home.dart';
import 'package:intl/intl.dart'; /* to enable DateFormat*/
import 'package:ibuy_mac_1/widgets/provider_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ibuy_mac_1/fixed_functionalities.dart';

class AcceptPlan extends StatelessWidget {
  final UserPlan userPlan;
  final db = FirebaseFirestore.instance;
  final String retailerID;

  AcceptPlan({Key key, @required this.userPlan, @required this.retailerID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          buildSelectedDetails(context),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: AutoSizeText.rich(
              TextSpan(
                text: "Get ",
                style: TextStyle(color: Colors.black, fontSize: 20.ssp),
                children: <TextSpan>[
                  TextSpan(
                      text: '${userPlan.cashback}% Cashback ',
                      style: TextStyle(
                          color: secondBase, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'by spending '),
                  TextSpan(
                      text: '\$${userPlan.budget.round()} ',
                      style: TextStyle(
                          color: starDark, fontWeight: FontWeight.bold)),
                  TextSpan(text: "at '${userPlan.retailerName}' in next "),
                  TextSpan(
                      text: '30 days ',
                      style: TextStyle(
                          color: starDark, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          '(before ${DateFormat('yMMMMd').format(userPlan.endDate.toDate()).toString()})'),

                  // TextSpan(
                  //     text: '\n\n -  Make as many visits as you like',
                  //     style: TextStyle(color: secondBase, fontSize: 18.ssp)),
                  // TextSpan(
                  //     text: '\n -  Upload receipts to iBuy',
                  //     style: TextStyle(color: secondBase, fontSize: 18.ssp)),
                  // TextSpan(
                  //     text: '\n -  Order your cashback from the App!',
                  //     style: TextStyle(color: secondBase, fontSize: 18.ssp)),
                  // TextSpan(
                  //     text: '\n -  Make as many visits as you want',
                  //     style: TextStyle(color: secondBase, fontSize: 18.ssp)),
                  TextSpan(
                      style: TextStyle(color: secondBase, fontSize: 18.ssp)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 0.07.sh,
            width: 0.4.sw,
            child: RaisedButton(
              child: Text('Get This Plan', style: TextStyle(fontSize: 18.ssp)),
              onPressed: () async {
                userPlan.status = "active";
                final uid =
                    await CustomProvider.of(context).auth.getCurrentUID();
                await db
                    .collection("userData")
                    .doc(uid)
                    .collection("userPlansActive")
                    .doc('active')
                    .set(userPlan.toJson());
                await db
                    .collection("userData")
                    .doc(uid)
                    .collection("userPlansActive")
                    .doc('active')
                    .update({'retailerID': retailerID});
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home(fabOn: true)),
                  (Route<dynamic> route) => true,
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 0.07.sh,
            width: 0.4.sw,
            child: RaisedButton(
              color: backLight,
              child: Text(
                'Dismiss',
                style: TextStyle(fontSize: 18.ssp),
              ),
              onPressed: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home(fabOn: false)),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelectedDetails(BuildContext context) {
    return Hero(
      tag: "SelectedTrip-${userPlan.retailerName}",
      transitionOnUserGestures: true,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: SingleChildScrollView(
            child: Card(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 16.0, bottom: 16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: AutoSizeText(userPlan.retailerName,
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontSize: 30.ssp,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              AutoSizeText("Cashback = ${userPlan.cashback}%",
                                  maxLines: 3,
                                  style: TextStyle(fontSize: 25.ssp)),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: <Widget>[
                              AutoSizeText(
                                  "Required Spend = \$${userPlan.budget.round()}",
                                  maxLines: 3,
                                  style: TextStyle(fontSize: 16.ssp)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
//                              AutoSizeText("Plan End Date: ${DateFormat('yMMMMd').format(userPlan.endDate).toString()}",
                              AutoSizeText(
                                  "Plan End Date: ${DateFormat('yMMMMd').format(userPlan.endDate.toDate()).toString()}",
                                  maxLines: 3,
                                  style: TextStyle(fontSize: 16.ssp)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Placeholder(
                          fallbackHeight: 50.h,
                          fallbackWidth: 50.w,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
