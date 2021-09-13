import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ibuy_mac_1/models/program.dart';
import 'package:ibuy_mac_1/models/user_profile.dart';

class DatabaseService {
  final String uid;
  DatabaseService({ this.uid });

//****************************************************
// RETAILERS PROGRAM DATA
  // collection reference for retailerPrograms
  final CollectionReference retailerPrograms = FirebaseFirestore.instance
      .collection('retailerPrograms');

  final CollectionReference userPlan = FirebaseFirestore.instance
      .collection('userData').doc().collection('userPlan');

  //create list of retailerPrograms from snapshot
  List<Program> _programsList(QuerySnapshot snapshot) {
    return snapshot.docs.map((docvar) {
      return Program(
        retailerName: docvar.data()['retailerName'] ?? '',
        spendRange: docvar.data()['spendRange'] ?? '',
        regionalCode: docvar.data()['regionalCode'] ?? '',
        minSpend: docvar.data()['minSpend'] ?? '',
        maxSpend: docvar.data()['maxSpend'] ?? '',
        cashback: docvar.data()['cashback'] ?? '',
        maxCustomers: docvar.data()['maxCustomers'] ?? '',
        startDate: docvar.data()['startDate'] ?? '',
        endDate: docvar.data()['endDate'] ?? '',
        storeCode: docvar.data()['storeCode'] ?? '',
        storeAddressNameAndNumber: docvar.data()['storeAddressNameAndNumber'] ?? '',
        storeAddressUnitNumber: docvar.data()['storeAddressUnitNumber'] ?? '',
        storeAddressCity: docvar.data()['storeAddressCity'] ?? '',
        storeAddressProvince: docvar.data()['storeAddressProvince'] ?? '',
        storeAddressPostalCode: docvar.data()['storeAddressPostalCode'] ?? '',
        storeLatitude: docvar.data()['storeLatitude'] ?? '',
        storeLongitude: docvar.data()['storeLongitude'] ?? '',

      );
    }).toList();
  }

  //get retailerProgram stream snapshot
  Stream<List<Program>> get programSnapshots {
    return retailerPrograms.snapshots()
        .map(_programsList);
  }

}

//add data to retailPrograms
// Future updateProgramsData(
//     String spendRange,
//     String retailerRegionCode,
//     String retailerCode,
//     String retailerName,
//     String regionalCode,
//     String regionCode,
//     String minSpend,
//     String maxSpend,
//     String baseCashback,
//     String topCashback,
//     String cashback,
//     String maxCustomers,
//     String startDate,
//     String endDate,
//     ) async {
//   return await programs.doc().set({
//     'spendRange': spendRange,
//     'retailerRegionCode': retailerRegionCode,
//     'retailerCode': retailerCode,
//     'retailerName': retailerName,
//     'regionalCode': regionalCode,
//     'regionCode': regionCode,
//     'minSpend': minSpend,
//     'maxSpend': maxSpend,
//     'baseCashback': baseCashback,
//     'topCashback': topCashback,
//     'cashback': cashback,
//     'maxCustomers': maxCustomers,
//     'startDate': startDate,
//     'endDate': endDate,
//   });
// }