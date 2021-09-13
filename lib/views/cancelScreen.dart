import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ibuy_mac_1/models/user_plan.dart';
import 'package:ibuy_mac_1/views/home.dart';
import 'package:ibuy_mac_1/widgets/provider_widget.dart';

import 'home_view.dart';

class CancelScreen extends StatelessWidget {
  final UserPlan userPlan;
  CancelScreen(this.userPlan);
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan Status'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Unfortunately your plan is cancelled',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
              ),
            ),
            Text(
              'You cancelled your plan order on xxx',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            Text(
              'You could have saved xxx',
              style: TextStyle(color: Colors.green, fontSize: 22),
            ),
            Text(
              'Please give it another try.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.amber)),
              child: Text('Create a new plan'),
              onPressed: () async {
                userPlan.status = "canceled";
                final uid =
                    await CustomProvider.of(context).auth.getCurrentUID();
                await db
                    .collection("userData")
                    .doc(uid)
                    .collection("userPlansCanceled")
                    .doc()
                    .set(userPlan.toJson());
                await db
                    .collection("userData")
                    .doc(uid)
                    .collection("userPlansActive")
                    .doc('active')
                    .delete();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                              fabOn: false,
                            )));
              },
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'Check ',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'iBuy Demo',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ]),
                  Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Check your ',
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'plan history',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.blue[700]),
                          ),
                        ]),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please share your',
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          ' feedback',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.blue[700]),
                        ),
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
