/*DEFINES THE STRUCTURE OF RETAILER PROGRAM*/
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Program {

  final String retailerName;
  final String spendRange;
  final String regionalCode;
  final String minSpend;
  final String maxSpend;
  final String cashback;
  final String maxCustomers;
  final String startDate;
  final String endDate;
  final String storeCode;
  final String storeAddressNameAndNumber;
  final String storeAddressUnitNumber;
  final String storeAddressCity;
  final String storeAddressProvince;
  final String storeAddressPostalCode;
  final String storeLatitude;
  final String storeLongitude;
        String docID;

  Program({
    this.retailerName,
    this.spendRange,
    this.regionalCode,
    this.minSpend,
    this.maxSpend,
    this.cashback,
    this.maxCustomers,
    this.startDate,
    this.endDate,
    this.storeCode,
    this.storeAddressNameAndNumber,
    this.storeAddressUnitNumber,
    this.storeAddressCity,
    this.storeAddressProvince,
    this.storeAddressPostalCode,
    this.storeLatitude,
    this.storeLongitude,
});

  //formatting for upload to firebase when creating retailer Program
  Map<String, dynamic> toJson() => {
    'retailerName': retailerName,
    'spendRange': spendRange,
    'regionalCode': regionalCode,
    'minSpend': minSpend,
    'maxSpend': maxSpend,
    'cashback': cashback,
    'maxCustomers': maxCustomers,
    'startDate': startDate,
    'endDate': endDate,
    'storeCode': storeCode,
    'storeAddressNameAndNumber': storeAddressNameAndNumber,
    'storeAddressUnitNumber': storeAddressUnitNumber,
    'storeAddressCity': storeAddressCity,
    'storeAddressProvince': storeAddressProvince,
    'storeAddressPostalCode': storeAddressPostalCode,
    'storeLatitude': storeLatitude,
    'storeLongitude': storeLongitude,
  };

  // creating a Programs object from Firebase snapshot
  Program.fromSnapshot(DocumentSnapshot snapshot):
      retailerName = snapshot['retailerName'],
      spendRange = snapshot['spendRange'],
      regionalCode = snapshot['regionalCode'],
      minSpend = snapshot['minSpend'],
      maxSpend = snapshot['maxSpend'],
      cashback = snapshot['cashback'],
      maxCustomers = snapshot['maxCustomers'],
      startDate = snapshot['startDate'],
      endDate = snapshot['endDate'],
      storeCode = snapshot['storeCode'],
      storeAddressNameAndNumber = snapshot['storeAddressNameAndNumber'],
      storeAddressUnitNumber = snapshot['storeAddressUnitNumber'],
      storeAddressCity = snapshot['storeAddressCity'],
      storeAddressProvince = snapshot['storeAddressProvince'],
      storeAddressPostalCode = snapshot['storeAddressPostalCode'],
      storeLatitude = snapshot['storeLatitude'],
      storeLongitude = snapshot['storeLongitude'],
      docID = snapshot.id;
}