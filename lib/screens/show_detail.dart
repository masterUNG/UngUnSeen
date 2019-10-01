import 'package:flutter/material.dart';
import 'package:ungunseen/models/unseen_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowDetail extends StatefulWidget {
  final UnseenModel unseenModel;
  ShowDetail({Key key, this.unseenModel}) : super(key: key);

  @override
  _ShowDetailState createState() => _ShowDetailState();
}

class _ShowDetailState extends State<ShowDetail> {
  // Explicit
  UnseenModel myUnseenModel;
  double lat = 0, lng = 0;
  LatLng myLatLng;

  // Method
  @override
  void initState() {
    super.initState();
    myUnseenModel = widget.unseenModel;
    lat = myUnseenModel.lat;
    lng = myUnseenModel.lng;
  }

  Widget showName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          myUnseenModel.name,
          style: TextStyle(fontSize: 20.0, color: Colors.blue.shade800),
        ),
      ],
    );
  }

  Widget showPic() {
    return Container(
      padding: EdgeInsets.all(20.0),
      height: 200.0,
      child: Image.network(myUnseenModel.urlPicture),
    );
  }

  Widget showDetail123() {
    return Text(myUnseenModel.detail);
  }

  Widget showMap() {
    myLatLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: myLatLng,
      zoom: 16.0,
    );

    return Container(
      margin: EdgeInsets.all(20.0),
      height: 400.0,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController googleMapController) {},
        markers: myMarker(),
      ),
    );
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('marker1'),
        position: myLatLng,
        infoWindow: InfoWindow(
          title: myUnseenModel.name,
          snippet: myUnseenModel.detail,
        ),
      ),
    ].toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: ListView(
        children: <Widget>[
          showName(),
          showPic(),
          showDetail123(),
          showMap(),
        ],
      ),
    );
  }
}
