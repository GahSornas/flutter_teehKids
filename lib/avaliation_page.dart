import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class avaliation_page extends StatefulWidget {
  const avaliation_page({super.key});

  @override
  State<avaliation_page> createState() => _avaliation_pageState();
}

class _avaliation_pageState extends State<avaliation_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TopBar
      appBar: AppBar(
        backgroundColor: Color(0xFFB8D5F5),
        centerTitle: true,
        title: Text('OdontApp'),
      )
    );
  }
}