/*THIS LIST VIEW DISPLAY FOR THE HOME_VIEW PAGE*/
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ibuy_mac_1/views/accept_plan.dart';
import 'package:provider/provider.dart';
import 'package:ibuy_mac_1/models/program.dart';
import 'package:ibuy_mac_1/models/user_profile.dart';
import 'package:ibuy_mac_1/models/user_plan.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ibuy_mac_1/fixed_functionalities.dart';

class ProgramList extends StatelessWidget {
  final UserPlan userPlan;
  final UserProfile userProfile;
  final String retailername;
  final String storeaddress;
  final String cashbackrangefire;
  final double storelogitude;
  final double storelatitude;
  final double distanceBetween;
  final String retailerID;
  ProgramList({
    Key key,
    @required this.userPlan,
    @required this.userProfile,
    @required this.retailername,
    @required this.storeaddress,
    @required this.cashbackrangefire,
    @required this.storelogitude,
    @required this.storelatitude,
    @required this.distanceBetween,
    @required this.retailerID,
  }) : super(key: key);

  /*define local variables*/

  @override
  Widget build(BuildContext context) {
    List<Program> _programsNew;
    String _postalCode = 'na';
    int _listLength = 0;
    final List<Program> programsAll = Provider.of<List<Program>>(context);
    _postalCode = userProfile.postalCode;
    print(userProfile.postalCode.toString());

    // if (programsAll != null && _postalCode != 'na') {
    //   _programsNew = programsAll
    //       .where((i) => (!i.retailername.contains('Metro') &&
    //           i.storepostalcode.contains(_postalCode.substring(0, 3))))
    //       .toList();
    // } else {
    //   _programsNew = [
    //     Program(
    //       banner: 'Please provide Postal Code',
    //       cashbackrange: 'na',
    //       id: 'na',
    //       maxcustomer: 'na',
    //       planenddate: 'na',
    //       planstartdate: '',
    //       plantemplateid: 'na',
    //       plantemplatename: null,
    //       retailername: null,
    //       spendrange: 0,
    //       storeaddressline1: 'na',
    //       storeaddressline2: 'na',
    //       storecity: 'na',
    //       storeid: 'na',
    //       storenumber: 'na',
    //       storepostalcode: '0',
    //       storestate: '0',
    //     )
    //   ];
    // }

    // _listLength = _programsNew.length;

    return programTile(context, userProfile);
  }

  programTile(BuildContext context, userProfile) {
    Timestamp _startDate = Timestamp.fromDate(DateTime.now());
    Timestamp _endDate =
        Timestamp.fromDate(DateTime.now().add(Duration(days: 30)));

    return Hero(
      //tag: "SelectedTrip-${userPlan.retailerName}",
      tag: _endDate,
      transitionOnUserGestures: true,
      child: Container(
        padding: EdgeInsets.only(top: 14),
        child: Card(
          color: Colors.amber[300],
          margin: EdgeInsets.only(left: 10, right: 10),
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          retailername.toString(),
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.ssp),
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            AutoSizeText(
                              storeaddress.toString(),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 15.ssp,
                                color: textLight,
                              ),
                            ),
                            AutoSizeText(
                              '   ',
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 10.ssp, color: Colors.red),
                            ),
                            AutoSizeText(
                              distanceBetween.toString(),
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 10.ssp, color: Colors.red),
                            ),
                            AutoSizeText(
                              ' km',
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 10.ssp, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(children: [
                    AutoSizeText(
                      cashbackrangefire.toString(),
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.ssp),
                    ),
                  ]),
                ],
              ),
            ),
            onTap: () {
              userPlan.retailerName = retailername;

              userPlan.cashback = double.parse(
                  cashbackrangefire.substring(0, cashbackrangefire.length));
              userPlan.startDate = _startDate;
              userPlan.endDate = _endDate;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AcceptPlan(userPlan: userPlan, retailerID: retailerID)),
              );
            },
          ),
        ),
      ),
    );
  }
}
