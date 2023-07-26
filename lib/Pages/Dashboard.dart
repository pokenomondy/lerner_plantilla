import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lerner_plantilla/Pages/Temario.dart';

class Dashboard extends StatefulWidget {


  @override
  _DashboardState createState() => _DashboardState();


}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('hola'),
          ElevatedButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Temario()),
            );
          }, child: Text('a temario')),
        ],
      ),
    );
  }


}