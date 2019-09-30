import 'package:flutter/material.dart';
import 'package:ungunseen/screens/my_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyService(),
    );
  }
}
