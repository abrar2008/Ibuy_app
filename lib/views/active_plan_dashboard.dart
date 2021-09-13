import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ibuy_mac_1/camera/image_capture.dart';
import 'package:ibuy_mac_1/models/user_plan.dart';
import 'package:ibuy_mac_1/views/dial_display_widget.dart';
import 'package:ibuy_mac_1/views/first_view.dart';
import 'package:ibuy_mac_1/views/get_plans.dart';
import 'package:ibuy_mac_1/views/home.dart';
import 'package:ibuy_mac_1/widgets/provider_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ibuy_mac_1/fixed_functionalities.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../camera/get_image.dart';
import './cancelScreen.dart';
import './targetAchievedScreen.dart';

class ActivePlanDashboard extends StatefulWidget {
  final UserPlan userPlan;

  ActivePlanDashboard({Key key, @required this.userPlan}) : super(key: key);

  @override
  _ActivePlanDashboardState createState() => _ActivePlanDashboardState();
}

class _ActivePlanDashboardState extends State<ActivePlanDashboard> {
  final db = FirebaseFirestore.instance;

  @override
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final daysLeft = widget.userPlan.endDate
        .toDate()
        .difference(widget.userPlan.startDate.toDate())
        .inDays;
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    var newFormat = DateFormat("yy MMM, dd");
    String updatedDt = newFormat.format(widget.userPlan.endDate.toDate());

    final _smallFont = 18.ssp;
    final _mediumFont = 20.ssp;
    final _bigFont = 24.ssp;
    Widget _getFAB() {
      return FloatingActionButton.extended(
        label: Text('Scan Receipts'),
        backgroundColor: secondBase,
        icon: Icon(Icons.receipt),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ImageCapture()));
        },
      );
    }

    bool _loading = false;
    void _onRefresh() async {
      // monitor network fetch
      // pop current page
      await Future.delayed(Duration(milliseconds: 1000));
      setState(() {
        _loading = true;
      });
      _refreshController.refreshCompleted();
      await Future.delayed(Duration(milliseconds: 1000));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    fabOn: false,
                  ))).then((value) => setState(() {
            _loading = false;
          })); // push it back in

      // if failed,use refreshFailed()

      // dynamic document = FirebaseFirestore.instance
      //     .collection('notification')
      //     .doc(user)
      //     .collection('data')
      //     .get();
      // if (document.toString() == null) {
      //   print(document.toString());
      //   _refreshController.refreshCompleted();
      // } else {
      //   _refreshController.refreshFailed();
      // }
      // var connectivityResult = await (Connectivity().checkConnectivity());
      // if (connectivityResult == ConnectivityResult.mobile) {
      //   _refreshController.refreshCompleted();
      // } else if (connectivityResult == ConnectivityResult.wifi) {
      //   _refreshController.refreshCompleted();
      // }
      // _refreshController.refreshFailed();
    }

    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : StreamBuilder<Object>(
            stream: FirebaseFirestore.instance
                .collection('userData')
                .doc(user)
                .collection('userPlansActive')
                .doc('active')
                .snapshots(),
            builder: (context, snapshot) {
              dynamic document = snapshot.data;
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (document.data()['targetAchieved'] >=
                  document.data()['budget']) {
                return Scaffold(
                  body: TargetAchievedScreen(widget.userPlan),
                );
              } else
                return Container(
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: SmartRefresher(
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        enablePullDown: true,
                        header: WaterDropMaterialHeader(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'You are almost there !!',
                              style: TextStyle(
                                  fontSize: _mediumFont,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            SizedBox(height: height * 0.015),
                            // Text('Retailer - ${userPlan.retailerName} '),
                            // Text('Cashback - ${userPlan.cashback}% Cashback '),
                            // Text('Spend - \$${userPlan.budget} '),
                            Container(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(height: height * 0.05),
                                                Stack(children: [
                                                  Container(
                                                    // color: Colors.red,
                                                    height: height * 0.19,
                                                    width: height * 0.19,
                                                    child: DialDisplayWidget(
                                                        userPlan:
                                                            widget.userPlan),
                                                  ),
                                                  Positioned(
                                                    top: height * 0.035,
                                                    left: width * 0.072,
                                                    child: Text(
                                                        '\$${widget.userPlan.targetAchieved.toInt().toString()}',
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          color:
                                                              Colors.blue[700],
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        )),
                                                  ),
                                                  Positioned(
                                                    left: width * 0.249,
                                                    top: height * 0.085,
                                                    child: Text(
                                                        '\$${widget.userPlan.budget.toInt().toString()}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  Positioned.fill(
                                                    top: height * 0.06,
                                                    right: width * 0.03,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            border: Border.all(
                                                                color:
                                                                    Colors.blue[
                                                                        800])),
                                                        child: Text(
                                                          '\$${widget.userPlan.budget.toInt() - widget.userPlan.targetAchieved.toInt()} left',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blue[800]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),

                                                // decoration: BoxDecoration(
                                                //     borderRadius: BorderRadius.circular(25),
                                                //     border: Border.all(
                                                //         color: Colors.blue[800])),
                                                // child:
                                              ]),
                                          Stack(children: [
                                            Image.asset(
                                              'assets/images/calender.png',
                                              height: height * 0.35,
                                              width: width * 0.35,
                                            ),
                                            Positioned.fill(
                                                top: height * 0.04,
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      daysLeft.toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[800],
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )))
                                          ]),
                                        ]),
                                  ),
//                     Positioned(
//                       top: 0.4.sw,
//                       // left: ,
//                       child: Container(0
//                         width: 0.9.sw,
//                         height: 0.17.sw,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Container(
//                               width: 0.4.sw,
//                               decoration: BoxDecoration(
// //                                  border: Border.all(color: backLight),
//                                 //borderRadius: BorderRadius.circular(3.r),
//                                 color: backDark,
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     child: Text(
//                                       'Time left',
//                                       style: TextStyle(
// //                                    fontWeight: FontWeight.bold,
//                                           fontSize: _smallFont,
//                                           color: leadBase),
//                                     ),
//                                   ),
//                                   SizedBox(height: 0.02.sw),
//                                   Text(
//                                     '$daysLeft days',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: _mediumFont,
// //                                    color: secondBase,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               width: 0.4.sw,
//                               decoration: BoxDecoration(
// //                                  border: Border.all(color: backLight),
//                                 borderRadius: BorderRadius.circular(3.r),
//                                 color: backDark,
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     'Pending spend',
//                                     style: TextStyle(
// //                                    fontWeight: FontWeight.bold,
//                                       fontSize: _smallFont,
//                                       color: leadBase,
//                                     ),
//                                   ),
//                                   SizedBox(height: 0.02.sw),
//                                   Text(
//                                     '\$${(userPlan.budget.toInt() - userPlan.targetAchieved.toInt())}',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: _mediumFont,
// //                                    color: secondBase,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
                                ],
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: 'Spend another ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          '\$${widget.userPlan.budget.toInt() - widget.userPlan.targetAchieved.toInt()}',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    TextSpan(
                                      text: ' to reach your target of',
                                      style: TextStyle(),
                                    ),
                                    TextSpan(
                                      text:
                                          ' \$${widget.userPlan.budget.toInt()}',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    TextSpan(
                                      text: ' at',
                                      style: TextStyle(),
                                    ),
                                    TextSpan(
                                      text: ' ${widget.userPlan.retailerName}',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    TextSpan(
                                      text: ' in next',
                                      style: TextStyle(),
                                    ),
                                    TextSpan(
                                      text: ' $daysLeft days',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    TextSpan(
                                      text: ' (by $updatedDt) to get cashback.',
                                      style: TextStyle(),
                                    ),
                                  ]),
                            ),
//
                            SizedBox(height: height * 0.02),

//TODO: Remove this button in the final version. User can change plan before accepting.
//TODO: An ongoing plan can be changed from 'Current Plan' under main Menu
                            Text(
                              "Don't like this plan?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: splashBase,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            SizedBox(
                              // height: height * 0.05,
                              // width: width * 0.70,

                              child: TextButton(
                                child: Text(
                                  'Cancel and Create New',
                                  style: TextStyle(
                                    fontSize: _mediumFont,
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CancelScreen(widget.userPlan)));
                                },
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              "OR",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: splashBase,
                              ),
                            ),
                            SizedBox(height: 30.h),
                            _getFAB(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
            });
  }
}
