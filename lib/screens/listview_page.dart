import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ungunseen/models/unseen_model.dart';

class ListViewPage extends StatefulWidget {
  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  // Explicit
  List<UnseenModel> unseenModels = [];

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
        // String name = snapshot.data['Name'];
        // print('name = $name');

        UnseenModel unseenModel = UnseenModel(
            snapshot.data['Name'],
            snapshot.data['Detail'],
            snapshot.data['UrlPicture'],
            snapshot.data['Code'],
            snapshot.data['Lat'],
            snapshot['Lng']);

        setState(() {
          unseenModels.add(unseenModel);
        });
      }
    });
  }

  Widget showPicture(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Image.network(unseenModels[index].urlPicture),
    );
  }

  Widget showText(int index) {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            unseenModels[index].name,
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            unseenModels[index].detail,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: unseenModels.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: index % 2 == 0
              ? BoxDecoration(color: Colors.blue.shade100)
              : BoxDecoration(color: Colors.blue.shade300),
          child: Row(
            children: <Widget>[
              showPicture(index),
              showText(index),
            ],
          ),
        );
      },
    );
  }
}
