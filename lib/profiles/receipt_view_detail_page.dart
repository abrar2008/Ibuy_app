import 'package:flutter/material.dart';

class ReceiptViewDetail extends StatelessWidget {
  final String retailerName;
  final String imageUrl;
  final String receiptID;
  ReceiptViewDetail({this.retailerName, this.imageUrl, this.receiptID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Receipt'),
      ),
      body: Hero(tag: imageUrl, child: Image.network(imageUrl)),
    );
  }
}
