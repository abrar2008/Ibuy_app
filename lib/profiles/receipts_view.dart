import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './receipt_view_detail_page.dart';

class ReceiptsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String user = FirebaseAuth.instance.currentUser.uid;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userData')
            .doc(user)
            .collection('url')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReceiptViewDetail(
                                retailerName: snapshot.data.docs[index]
                                    ['retailerName'],
                                imageUrl: snapshot.data.docs[index]['imageUrl'],
                                receiptID: snapshot.data.docs[index]
                                    ['recieptID'])),
                      );
                    },
                    child: Card(
                        child: ListTile(
                      title: Text(
                          'Retailer: ${snapshot.data.docs[index]['retailerName']}'),
                      leading: Hero(
                        tag: '${snapshot.data.docs[index]['imageUrl']}',
                        child: Image.network(
                            snapshot.data.docs[index]['imageUrl']),
                      ),
                      subtitle: Text(
                          ' Reciept ID: ${snapshot.data.docs[index]['recieptID']}'),
                    )),
                  );
                });
          } else {
            return Center(child: Text('No receipts'));
          }
        },
      ),
    );
  }
}
