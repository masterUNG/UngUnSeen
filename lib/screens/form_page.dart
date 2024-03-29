import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:ungunseen/screens/my_service.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Explicit
  File file;
  double lat = 0, lng = 0;
  bool imageBool = false; // false ==> Non Choose Image
  final formKey = GlobalKey<FormState>();
  String name, detail, code, urlPicture;

  // Method
  @override
  void initState() {
    super.initState();
    findLatLng();
    createCode();
  }

  void createCode() {
    int randInt = Random().nextInt(10000);
    code = 'code$randInt';
  }

  Future<void> findLatLng() async {
    var curentLocatoin = await findLocationData();

    if (curentLocatoin == null) {
      myAlert('Permission Check', 'Please Open Location Permission');
    } else {
      setState(() {
        lat = curentLocatoin.latitude;
        lng = curentLocatoin.longitude;
      });
    }
  }

  Future<LocationData> findLocationData() async {
    var location = Location();

    try {
      return await location.getLocation();
    } catch (e) {
      print('Error = $e');
      return null;
    }
  }

  Widget nameText() {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 50.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Name :',
          helperText: 'Type Your Display Name',
          hintText: 'English Only',
          icon: Icon(Icons.face),
        ),
        onSaved: (String value) {
          name = value.trim();
        },
      ),
    );
  }

  Widget detailText() {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 50.0),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: 'Detail :',
          helperText: 'Type Your Detail',
          icon: Icon(Icons.details),
        ),
        onSaved: (String value) {
          detail = value.trim();
        },
      ),
    );
  }

  Widget showImage() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      height: 200.0,
      child: file == null ? Image.asset('images/pic.png') : Image.file(file),
    );
  }

  Widget showButton() {
    return Container(
      width: 200.0,
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          cameraButton(),
          galleryButton(),
        ],
      ),
    );
  }

  Widget cameraButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 48.0,
        color: Colors.purple.shade400,
      ),
      onPressed: () {
        cameraThread();
      },
    );
  }

  Future<void> cameraThread() async {
    var imageObject = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 800.0, maxHeight: 480.0);
    setState(() {
      file = imageObject;
      imageBool = true;
    });
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 48.0,
        color: Colors.green,
      ),
      onPressed: () {
        galleryThread();
      },
    );
  }

  Future<void> galleryThread() async {
    var imageObject = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imageObject;
      imageBool = true;
    });
  }

  Widget showLat() {
    return Column(
      children: <Widget>[
        Text(
          'Latitude',
          style: TextStyle(fontSize: 20.0),
        ),
        Text('$lat')
      ],
    );
  }

  Widget showLng() {
    return Column(
      children: <Widget>[
        Text(
          'Longitude',
          style: TextStyle(fontSize: 20.0),
        ),
        Text('$lng')
      ],
    );
  }

  Widget uploadValueButton() {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.cloud_upload),
            onPressed: () {
              if (imageBool) {
                formKey.currentState.save();
                if ((name.isEmpty) || (detail.isEmpty)) {
                  myAlert('Have Space', 'Please Fill Every Blank');
                } else {
                  print(
                      'name = $name, detail = $detail, lat = $lat, lng = $lng, code = $code');
                  uploadFileToStorage();
                }
              } else {
                myAlert('Non Choose Image',
                    'Please Choose Image From Camera or Gallery');
              }
            },
          ),
        ],
      ),
    );
  }

  Future uploadFileToStorage() async {
    String namePicture = '$code.jpg';

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Picture/$namePicture');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);

    await (await storageUploadTask.onComplete)
        .ref
        .getDownloadURL()
        .then((response) {
      urlPicture = response;
      print('urlPicture = $urlPicture');
      updateValueToFireStore();
    });
  }

  Future<void> updateValueToFireStore() async {
    Firestore firestore = Firestore.instance;

    Map<String, dynamic> map = Map();
    map['Name'] = name;
    map['Detail'] = detail;
    map['Lat'] = lat;
    map['Lng'] = lng;
    map['Code'] = code;
    map['UrlPicture'] = urlPicture;

    await firestore
        .collection('Unseen')
        .document()
        .setData(map)
        .then((response) {
      print('Update Success');

      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => MyService());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.only(bottom: 50.0, right: 10.0, left: 10.0),
        children: <Widget>[
          showImage(),
          showButton(),
          nameText(),
          detailText(),
          SizedBox(
            height: 16.0,
          ),
          showLat(),
          showLng(),
          uploadValueButton(),
        ],
      ),
    );
  }
}
