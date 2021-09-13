import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './notification_detail.dart';
import 'dart:io';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final String user = FirebaseAuth.instance.currentUser.uid;
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    Future<void> _onRefresh() async {
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
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

    void _onLoading() async {
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use loadFailed(),if no data return,use LoadNodata()

      setState(() {});
      _refreshController.loadComplete();
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('notification')
              .doc(user)
              .collection('data')
              .orderBy('timeStamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return Container(
                height: size.height,
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  header: WaterDropHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = Text("pull up load");
                      } else if (mode == LoadStatus.loading) {
                        body = CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = Text("release to load more");
                      } else {
                        body = Text("No more Data");
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      int daysPassed = DateTime.now()
                          .difference(
                              snapshot.data.docs[index]['timeStamp'].toDate())
                          .inDays;
                      String getDays() {
                        if (daysPassed == 0) {
                          return 'Today';
                        }
                        if (daysPassed == 1) {
                          return 'Yesterday';
                        } else {
                          return '$daysPassed days ago';
                        }
                      }

                      Color getColors() {
                        if (snapshot.data.docs[index]['notificationbanner'] ==
                            0) {
                          return Colors.amber[100];
                        } else {
                          return Colors.white;
                        }
                      }

                      Color notificationColors() {
                        if (snapshot.data.docs[index]['notificationbanner'] ==
                            0) {
                          return Colors.red[500];
                        } else {
                          return Colors.white;
                        }
                      }

                      TextSpan acceptedOrRejected({String totalSpent}) {
                        if (snapshot.data.docs[index]['ApprovalStatus'] == 1)
                          return TextSpan(
                              text:
                                  'Your \$$totalSpent has been rejected. Please contact iBuy suppport team.',
                              style: TextStyle(color: Colors.red[700]));
                        else
                          return TextSpan(
                              text: 'Your \$$totalSpent has been approved',
                              style: TextStyle(color: Colors.black54));
                      }

                      return GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationDetail(
                                      notificationBanner: snapshot.data
                                          .docs[index]['notificationbanner'],
                                      approvalStatus: snapshot.data.docs[index]
                                          ['ApprovalStatus'],
                                      getDays: getDays(),
                                      totalSpent: snapshot.data.docs[index]
                                          ['TotalSpend'],
                                      retailerName: snapshot.data.docs[index]
                                          ['retailerName'],
                                      getAcceptedOrRejectedtext:
                                          acceptedOrRejected(
                                        totalSpent: snapshot.data.docs[index]
                                            ['TotalSpend'],
                                      ),
                                    )),
                          );
                          await FirebaseFirestore.instance
                              .collection('notification')
                              .doc(user)
                              .collection('data')
                              .doc(snapshot.data.docs[index].id)
                              .update({'notificationbanner': 1});
                        },
                        child: ListTile(
                          tileColor: getColors(),
                          title: Text(snapshot.data.docs[index]['retailerName'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: RichText(
                            text: TextSpan(
                                text:
                                    //                   userPlan.endDate
                                    // .toDate()
                                    // .difference(userPlan.startDate.toDate())
                                    // .inDays;
                                    '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                                children: [
                                  acceptedOrRejected(
                                      totalSpent:
                                          '${snapshot.data.docs[index]['TotalSpend']}'),
                                  TextSpan(
                                    text: '\n${getDays()}',
                                    style: TextStyle(color: Colors.green),
                                  )
                                ]),
                          ),
                          isThreeLine: true,
                          trailing: Icon(
                            Icons.notification_important,
                            color: notificationColors(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              return Center(
                child: Text('You have no activity'),
              );
            }
          }),
    );
  }
}
