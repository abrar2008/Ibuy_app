import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fontisto_flutter/fontisto_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  //Active image file
  File _imageFile;

  //select an image via Gallery or Camera
  _pickImage(ImageSource source) async {
    final selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = File(selected.path);
    });
  }

  //remove image
  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.yellow,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                if(_imageFile != null) ...[
                  Image.file(_imageFile),
                  Row(
                    children: [
                      Uploader(file: _imageFile),
                      SizedBox(width: MediaQuery.of(context).size.width*0.3),
                      FlatButton(
                        onPressed: _clear,
                        child: Icon(Icons.delete),
                      ),
                    ],
                  ),

                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;
  Uploader ({Key key, this.file}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://ibuy-mac-1.appspot.com');

  StorageUploadTask _uploadTask;

  void _startUpload () {
    String filePath = 'images/${DateTime.now()}.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;
          double progressPercent = event != null
          ? event.bytesTransferred / event.totalByteCount
              : 0;
          return Column(
            children: [
              if(_uploadTask.isComplete)
                FlatButton.icon(
                  label: Text('Done'),
                  icon: Icon(Icons.done),
                  onPressed: () {},
                ),

              if(_uploadTask.isInProgress)
                FlatButton(
                  child: CircularProgressIndicator(),
                  onPressed: () {},
                ),

              // if(_uploadTask.isPaused)
              //   FlatButton(
              //     child: Icon(Icons.play_arrow),
              //     onPressed: _uploadTask.resume,
              //   ),
              //
              // if(_uploadTask.isInProgress)
              //   FlatButton(
              //     child: Icon(Icons.pause),
              //     onPressed: _uploadTask.pause,
              //   ),

              // LinearProgressIndicator(value: progressPercent),
              // Text(
              //   '${(progressPercent * 100).toStringAsFixed(2)} % '
              // ),
            ],
          );
        },
      );

    } else {
      return FlatButton.icon(
        label: Text('Upload to iBuy'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }
}