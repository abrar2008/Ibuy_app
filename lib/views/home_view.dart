/*ASKS USER TO ENTER SPEND AND DISPLAYS RETAILERS & CASHBACK*/
/*THIS IS HOME CLASS -> CONSISTS OF APPBAR, HOME_VIEW, FLOATING ACTION BUTTON*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibuy_mac_1/views/active_plan_dashboard.dart';
import 'package:ibuy_mac_1/views/enter_budget.dart';
import 'package:ibuy_mac_1/models/user_plan.dart';
import 'package:ibuy_mac_1/models/user_profile.dart';
import 'package:ibuy_mac_1/widgets/provider_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ibuy_mac_1/fixed_functionalities.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    //Initiate user plan
    final newPlan = UserPlan(
      'na',
      null,
      null,
      0,
      0,
      0,
      'na',
      'na', /*, 0.0, 0.0, 0.0, 0.0*/
    );
    final userProfile = UserProfile('na', 'na', 'na', 'na', 'na', 'na', 'na',
        'na', 0.0, 0.0, 0.0, 0.0, 'na', 'na');

    return Container(
      child: FutureBuilder(
          future: _getProfileData(context, userProfile),
          builder: (context, snapshot) {
            return Container(
              child: StreamBuilder(
                  stream: getUsersPlansStreamSnapshots(context),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                      return EnterBudget(
                          userPlan: newPlan, userProfile: userProfile);
                    } else {
                      final thisPlan =
                          UserPlan.fromSnapshot(snapshot.data.docs[0]);
                      return ActivePlanDashboard(userPlan: thisPlan);
                    }
                  }),
            );
          }),
    );
  }

  _getProfileData(context, userProfile) async {
    final uid = await CustomProvider.of(context).auth.getCurrentUID();
    await CustomProvider.of(context)
        .db
        .collection('userData')
        .doc(uid)
        .get()
        .then((result) {
      userProfile.userName = result.data()['userName'];
      userProfile.address1 = result.data()['address1'];
      userProfile.address2 = result.data()['address2'];
      userProfile.address3 = result.data()['address3'];
      userProfile.city = result.data()['city'];
      userProfile.state = result.data()['state'];
      userProfile.country = result.data()['country'];
      userProfile.postalCode = result.data()['postalCode'];
      userProfile.userLat = result.data()['userLat'];
      userProfile.userLng = result.data()['userLng'];
      userProfile.tempLat = result.data()['tempLat'];
      userProfile.tempLng = result.data()['tempLng'];
      userProfile.cardNumberLastFour = result.data()['cardNumberLastFour'];
      userProfile.cardType = result.data()['cardType'];
    });
  }

  Stream<QuerySnapshot> getUsersPlansStreamSnapshots(
      BuildContext context) async* {
    final uid = await CustomProvider.of(context).auth.getCurrentUID();
    yield* FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .collection('userPlansActive')
        .snapshots();
  }
}
