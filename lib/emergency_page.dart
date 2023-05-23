import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(EmergenciesPage());
}

class EmergenciesPage extends StatelessWidget {
   EmergenciesPage({super.key});

  var db = FirebaseFirestore.instance;


  getInfo() async{
    var infoEmergencies = db.collection("emergencia");
    await db.collection('emergencias').get().then((event) => {
      for (var doc in event.docs) {
      print("${doc.id} => ${doc.data()}")
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBAE8E8),
        title: const Text('TeehKids'),
      ),
      body: Scaffold(
        
      )
    );
  }
}