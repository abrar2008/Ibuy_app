import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ibuy_mac_1/models/user_plan.dart';
import 'package:ibuy_mac_1/views/home.dart';
import 'package:ibuy_mac_1/views/home_view.dart';
import 'package:ibuy_mac_1/widgets/provider_widget.dart';
import '../fixed_functionalities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TargetAchievedScreen extends StatelessWidget {
  final UserPlan userPlan;
  TargetAchievedScreen(this.userPlan);
  final db = FirebaseFirestore.instance;
  var a = 1;
  @override
  Widget build(BuildContext context) {
    final String user = FirebaseAuth.instance.currentUser.uid;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Congractulations'),
          Text('You have saved \$xx'),
          SizedBox(
            height: 10.h,
          ),
          Text('Ready to create your new plan?'),
          StreamBuilder<Object>(
              stream: FirebaseFirestore.instance
                  .collection('CashbackRequests')
                  .doc(user)
                  .snapshots(),
              builder: (context, snapshot) {
                dynamic document = snapshot.data;
                return ElevatedButton(
                  child: Text('Create a New plan'),
                  onPressed: () async {
                    userPlan.status = "completed";

                    await db
                        .collection("userData")
                        .doc(user)
                        .collection("userPlansCompleted")
                        .doc()
                        .set(userPlan.toJson());
                    await db
                        .collection("userData")
                        .doc(user)
                        .collection("userPlansActive")
                        .doc('active')
                        .delete();
                    if (!document.exists) {
                      await db.collection('CashbackRequests').doc(user).set({
                        'accountBalance': userPlan.budget * userPlan.cashback,
                      });
                      await db.collection('CashbackRequests').doc(user).set({
                        'cashBackEarnedTillDate':
                            userPlan.budget * userPlan.cashback,
                      });
                    } else {
                      await db.collection('CashbackRequests').doc(user).update({
                        'accountBalance': document.data()['accountBalance'] +
                            userPlan.budget * userPlan.cashback,
                      });
                      await db.collection('CashbackRequests').doc(user).update({
                        'cashBackEarnedTillDate':
                            document.data()['cashBackEarnedTillDate'] +
                                userPlan.budget * userPlan.cashback,
                      });
                    }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(fabOn: false)));
                  },
                );
              }),
          SizedBox(
            height: 10.h,
          ),
          Text('Check')
        ],
      ),
    );
  }
}
