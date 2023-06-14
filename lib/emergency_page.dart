import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

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

  final functions = FirebaseFunctions.instance;

  final firestoreInstance = FirebaseFirestore.instance;

  final HttpsCallable callable =
      FirebaseFunctions.instanceFor(region: 'southamerica-east1')
          .httpsCallable('listAllEmergencies');

  Future<List<dynamic>> callFirebaseFunction() async {
    try {
      final result = await callable.call();
      final List<dynamic> data = result.data;
      return data;
    } catch (e) {
      print('Error calling Firebase function: $e');
      return [];
    }
  }

  Future<void> _callCloudFunction() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: 'southamerica-east1')
              .httpsCallable('getAcceptedBy');

      final response =
          await callable.call({'uid': 'Fg1o5OMIGNdlWxhP6ZrkzxMjNPD3'});
      final data = response.data as List<dynamic>;

      // Handle the result as per your needs
      print(data);
    } catch (e) {
      // Handle any errors that occur during the function call
      print('Error calling Cloud Function: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBAE8E8),
        title: const Text('TeehKids'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Call Cloud Function'),
          onPressed: () {
            _callCloudFunction();
          },
        ),
      ),
    );
  }
}