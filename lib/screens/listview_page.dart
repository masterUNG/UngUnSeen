import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListViewPage extends StatefulWidget {
  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  // Explicit

  // Mathod
  @override
  void initState() {
    super.initState();
    readDataFireStore();
  }

  Future<void> readDataFireStore() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Unseen');
    await collectionReference.snapshots().listen((response) {

        List<DocumentSnapshot> snapshots = response.documents;
        for (var snapshot in snapshots) {
          String name = snapshot.data['Name'];
          print('name = $name');
        }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('This is ListView Page');
  }
}
