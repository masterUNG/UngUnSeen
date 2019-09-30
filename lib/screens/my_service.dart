import 'package:flutter/material.dart';
import 'package:ungunseen/screens/form_page.dart';
import 'package:ungunseen/screens/listview_page.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  // Explicit
  Widget currentWidget = FormPage();

  // Method
  Widget menuFormPage() {
    return ListTile(
      leading: Icon(
        Icons.filter_1,
        size: 36.0,
        color: Colors.blue,
      ),
      title: Text('Form'),
      subtitle: Text('Form Page for Input Value'),
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          currentWidget = FormPage();
        });
      },
    );
  }

  Widget menuListViewPage() {
    return ListTile(
      leading: Icon(
        Icons.filter_2,
        size: 36.0,
        color: Colors.purple,
      ),
      title: Text('ListView'),
      subtitle: Text('หน้าที่ แสดง ข้อมูล การท่องเที่ยวของเรา'),onTap: (){
        Navigator.of(context).pop();
        setState(() {
          currentWidget = ListViewPage();
        });
      },
    );
  }

  Widget showLogo() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget myHead() {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wallpaper.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          showLogo(),
          Text(
            'Ung Unseen',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.blue.shade800,
            ),
          ),
          Text('Share Every Thing from Thailand'),
        ],
      ),
    );
  }

  Widget myDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          myHead(),
          menuFormPage(),
          Divider(),
          menuListViewPage(),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Service'),
      ),
      body: currentWidget,
      drawer: myDrawer(),
    );
  }
}
