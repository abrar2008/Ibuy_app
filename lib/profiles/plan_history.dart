import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlanHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String user = FirebaseAuth.instance.currentUser.uid;
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('userData')
              .doc(user)
              .collection('userPlansCanceled')
              .orderBy('ate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            dynamic document = snapshot.data.docs;
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: document.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('${document[index]['retailerName']}'),
                      subtitle: Text('budget: \$${document[index]['budget']}'),
                      trailing: Text(
                          'Target Achieved \$${document[index]['targetAchieved'].toInt()}'),
                      leading: Text(
                          'Start date: \n${document[index]['startDate'].toDate().day}/${document[index]['startDate'].toDate().month}/${document[index]['startDate'].toDate().year}'),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('You have no cancelled history!'));
            }
          }),
    );
  }
}
