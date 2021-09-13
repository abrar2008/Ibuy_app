import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ibuy_mac_1/models/user_plan.dart';
import 'package:ibuy_mac_1/widgets/progress_arc.dart';
import 'package:ibuy_mac_1/widgets/progress_donut.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/progress_arc2.dart';

class DialDisplayWidget extends StatefulWidget {
  final UserPlan userPlan;

  DialDisplayWidget({Key key, @required this.userPlan}) : super(key: key);

  @override
  _DialDisplayWidgetState createState() => _DialDisplayWidgetState();
}

class _DialDisplayWidgetState extends State<DialDisplayWidget>
    with SingleTickerProviderStateMixin {
  final db = FirebaseFirestore.instance;
  AnimationController progressController;
  Animation<double> animation;
  double pctSpendAchieved;
  bool _loading = true;
  final String user = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    double sum = 0;
    Future<double> queryValues() async {
      double total = 0;

      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;

//User user= await _auth.currentUser();
      await FirebaseFirestore.instance
          .collection('notification')
          .doc(user.uid)
          .collection('data')
          // .where('retailerName', isEqualTo: widget.userPlan.retailerName)
          .where('timeStamp', isGreaterThanOrEqualTo: widget.userPlan.startDate)
          .where('timeStamp', isLessThanOrEqualTo: widget.userPlan.endDate)

          // .where('ApprovalStatus', isEqualTo: 1)
          .get()
          .then((sums) {
            if (sums != null) {
              sums.docs.forEach((value) {
                if (value.data()['retailerName'] ==
                    widget.userPlan.retailerName) {
                  if (value.data()['ApprovalStatus'] == 0)
                    total = total + double.parse(value.data()['TotalSpend']);
                  print(value.data()['retailerName']);
                }
              });
            } else {
              total = 0;
            }
          })
          .then((value) => setState(() {
                sum = total;
              }))
          .then((value) {
            if (sum == 0) {
              setState(() {
                pctSpendAchieved = 100 * 0 / widget.userPlan.budget;
                progressController = AnimationController(
                    vsync: this, duration: Duration(milliseconds: 1000));
                animation = Tween<double>(begin: 0, end: pctSpendAchieved)
                    .animate(CurvedAnimation(
                        parent: progressController, curve: Curves.decelerate))
                      ..addListener(() {
                        setState(() {});
                      });
                progressController.forward();
              });
            } else
              setState(() {
                pctSpendAchieved = 100 * sum / widget.userPlan.budget;
                progressController = AnimationController(
                    vsync: this, duration: Duration(milliseconds: 1000));
                animation = Tween<double>(begin: 0, end: pctSpendAchieved)
                    .animate(CurvedAnimation(
                        parent: progressController, curve: Curves.decelerate))
                      ..addListener(() {
                        setState(() {});
                      });
                progressController.forward();
              });
          })
          .then((value) async => await FirebaseFirestore.instance
              .collection('userData')
              .doc(user.uid)
              .collection('userPlansActive')
              .doc('active')
              .update({'targetAchieved': sum}))
          .then((value) => setState(() {
                _loading = false;
              }));

      return total;
    }

    queryValues();
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return _loading
        ? Container()
        : Stack(
            // fit: StackFit.expand,
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: CustomPaint(
                  size: Size(125.w, 125.w),
                  foregroundPainter:
                      ProgressArc2(null, Colors.blueGrey[50], true),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(5),
                child: CustomPaint(
                  size: Size(125.w, 125.w),
                  foregroundPainter:
                      ProgressArc(animation.value, Colors.amber, false),
                ),
              ),

              // Center(
              //   child: Text('${animation.value.toInt()}%',
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // Center(child: Text("About")),
            ],
          );
  }
}
