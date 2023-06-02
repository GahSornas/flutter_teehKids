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

  getInfo() async {
    var infoEmergencies = db.collection("emergencia");
    await db.collection('emergencias').get().then((event) => {
          for (var doc in event.docs) {print("${doc.id} => ${doc.data()}")}
        });
  }

  final firestoreInstance = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBAE8E8),
        title: const Text('TeehKids'),
      ),
      body: Container(
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('emergencias').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Container(
                  child: Text(snapshot.data!.docs[index]['nome']),
                ),
              );
            } else
              return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: retrieveDoctors),
    );
  }

  void retrieveDoctors() {
    firestoreInstance.collection('emergencias').get().then(
      (value) {
        value.docs.forEach(
          (result) {
            firestoreInstance.collection('emergencias').doc(result.id);
            print(result.data());
          },
        );
      },
    );
  }
}