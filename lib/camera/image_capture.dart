import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';


final String user = FirebaseAuth.instance.currentUser.uid;

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  //Create new instance of the picker
  final ImagePicker _picker = ImagePicker();

  //Active image file
 var _imageFile;

  //Select image by gallery or camera
  Future<void> _pickImage(ImageSource source) async {
  /*  PickedFile selected = await _picker.getImage(source: ImageSource.camera);*/
    final image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxWidth: 480.0,
      maxHeight: 720.0,
    );
    setState(() {
      if (image != null) {
        _imageFile = image;
      } else {
        print('No image selected.');
      }
    });
  }

  //Remove file
  void _clear() {
    setState(() => _imageFile = null);

    _pickImage(ImageSource.camera);
  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    _pickImage(ImageSource.camera);
  }

  void dispose() {
    super.dispose();
    Navigator.pop(context);
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
//    final height = MediaQuery.of(context).size.height;
//    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        // bottomNavigationBar: SizedBox(
        //   height: 0.1.sh,
        //   child: BottomAppBar(
        //     color: Colors.blueGrey,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: [
        //         SizedBox(
        //           height: 0.065.sh,
        //           width: 0.4.sw,
        //           child: RaisedButton.icon(
        //             label: Text(
        //               'Camera',
        //               style: TextStyle(fontSize: 16.ssp),
        //             ),
        //             color: Colors.blueGrey[400],
        //             splashColor: Colors.amber,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(40.r),
        //             ),
        //             icon: Icon(
        //               Icons.photo_camera,
        //               size: 30.w,
        //             ),
        //             onPressed: () => _pickImage(ImageSource.camera),
        //           ),
        //         ),
        //         SizedBox(
        //           height: 0.065.sh,
        //           width: 0.4.sw,
        //           child: RaisedButton.icon(
        //             label: Text(
        //               'Photos',
        //               style: TextStyle(fontSize: 16.ssp),
        //             ),
        //             color: Colors.blueGrey[400],
        //             splashColor: Colors.amber,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(40.r),
        //             ),
        //             icon: Icon(
        //               Icons.photo,
        //               size: 30.w,
        //             ),
        //             onPressed: () => _pickImage(ImageSource.gallery),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: Container(
            width: 1.0.sw,
            child: Stack(children: [
              if (_imageFile != null) ...[
                ListView(children: [
                  Image.file(File(_imageFile.path)),
                ]),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    child: Container(
                      color: Colors.black54,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 60.h,
                            width: 100.w,
                            child: TextButton(
                              child: Icon(Icons.refresh,
                                  size: 30.w, color: Colors.white),
                              onPressed: _clear,
                            ),
                          ),
                          SizedBox(
                              /*height: 60, width: 100,*/
                              child: Uploader(file: File(_imageFile.path))),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else
                ...[]
            ])));
  }
}

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, @required this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://ibuy-ed180.appspot.com');

  StorageUploadTask _uploadTask;

  Future<void> _startUpload(
    userName,
    address1,
    address2,
    address3,
    cardType,
    cardNumberLastFour,
    country,
    postalCode,
    state,
    city,
    retailerName,
    budget,
    cashback,
    endDate,
    postalCodeRetailer,
    startDate,
    statusOfRetailer,
    targetAchieved,
  ) async {
    String filePath = 'images/${DateTime.now()}.png';
    DocumentReference docID;
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
    var dowurl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    String downloadURL = dowurl.toString();
    await FirebaseFirestore.instance
        .collection('userData')
        .doc(user)
        .collection('url')
        .add({
          'imageUrl': downloadURL,
          'approved': 0,
          'userName': userName,
          'address1': address1,
          'address2': address2,
          'address3': address3,
          'cardType': cardType,
          'cardNumberLastFour': cardNumberLastFour,
          'country': country,
          'postalCode': postalCode,
          'state': state,
          'city': city,
          'retailerName': retailerName,
          'budget': budget,
          'cashback': cashback,
          'endDate': endDate,
          'postalCodeRetailer': postalCodeRetailer,
          'startDate': startDate,
          'statusOfRetailer': statusOfRetailer,
          'targetAchieved': targetAchieved,
          'customerID': user,
        })
        .then((value) async => setState(() {
              docID = value;
            }))
        .then((value) => FirebaseFirestore.instance
                .collection('userData')
                .doc(user)
                .collection('url')
                .doc(docID.id)
                .update({
              'recieptID': docID.id,
            }))
        .then((value) async => await FirebaseFirestore.instance
                .collection('admin')
                .doc(docID.id)
                .set({
              'imageUrl': downloadURL,
              'approved': 0,
              'userName': userName,
              'address1': address1,
              'address2': address2,
              'address3': address3,
              'cardType': cardType,
              'cardNumberLastFour': cardNumberLastFour,
              'country': country,
              'postalCode': postalCode,
              'state': state,
              'city': city,
              'retailerName': retailerName,
              'budget': budget,
              'cashback': cashback,
              'endDate': endDate,
              'postalCodeRetailer': postalCodeRetailer,
              'startDate': startDate,
              'statusOfRetailer': statusOfRetailer,
              'targetAchieved': targetAchieved,
              'customerID': user,
              'recieptID': docID.id,
            }));
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;
            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_uploadTask.isComplete)
                  TextButton(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30.w,
                    ),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/home');
                    },
                  ),

                if (_uploadTask.isPaused)
                  TextButton(
                    child: Icon(
                      Icons.play_arrow,
                      size: 30.w,
                    ),
                    onPressed: _uploadTask.resume,
                  ),

                if (_uploadTask.isInProgress)
                  TextButton(
                    child: Container(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )),
                    onPressed: _uploadTask.pause,
                  ),

                // SizedBox(
                //   height: 10,
                //   width: 100,
                //   child: LinearProgressIndicator(minHeight: 5,
                //       value: progressPercent
                //   ),
                // ),
                // Text('${(progressPercent * 100).toStringAsFixed(2)} %'),
              ],
            );
          });
    } else {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('userData')
              .doc(user)
              .collection('userPlansActive')
              .doc('active')
              .snapshots(),
          builder: (context, snapshot2) {
            dynamic documentForRetailer = snapshot2.data;
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userData')
                    .doc(user)
                    .snapshots(),
                builder: (context, snapshot) {
                  dynamic document = snapshot.data;
                  return TextButton(
                    child: Text(
                      "Upload",
                      style: TextStyle(fontSize: 16.ssp, color: Colors.white),
                    ),
                    onPressed: () {
                      _startUpload(
                        document.data()['userName'],
                        document.data()['address1'],
                        document.data()['address2'],
                        document.data()['address3'],
                        document.data()['cardType'],
                        document.data()['cardNumberLastFour'],
                        document.data()['country'],
                        document.data()['postalCode'],
                        document.data()['state'],
                        document.data()['city'],
                        documentForRetailer.data()['retailerName'],
                        documentForRetailer.data()['budget'],
                        documentForRetailer.data()['cashback'],
                        documentForRetailer.data()['endDate'],
                        documentForRetailer.data()['postalCode'],
                        documentForRetailer.data()['startDate'],
                        documentForRetailer.data()['status'],
                        documentForRetailer.data()['targetAchieved'],
                      );
                    },
                  );
                });
          });
    }
  }
}
