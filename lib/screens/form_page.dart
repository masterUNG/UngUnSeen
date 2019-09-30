import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Explicit
  File file;

  // Method
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

  Future<void> cameraThread()async{

    var imageObject = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      file = imageObject;
    });

  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(Icons.add_photo_alternate, size: 48.0,color: Colors.green,),
      onPressed: () {
        galleryThread();
      },
    );
  }

  Future<void> galleryThread()async{
    var imageObject = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imageObject;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        showImage(),
        showButton(),
      ],
    );
  }
}
