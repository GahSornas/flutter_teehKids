import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // List<String> nomes = [];
  // Future<String?> _callCloudFunction() async {
  //   //pegar UID
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user = auth.currentUser;

  //   if (user != null) {
  //     String uid = user.uid;
  //     print('UID do usuário: $uid');
  //   } else {
  //     print('Usuário não autenticado.');
  //   }

  //   try {
  //     final HttpsCallable callable =
  //         FirebaseFunctions.instanceFor(region: 'southamerica-east1')
  //             .httpsCallable('getAcceptedBy');

  //     final response = await callable.call({'uid': user?.uid});
  //     final data = response.data as List<dynamic>;

  //     //loop para pegar informações separadas e printar no terminal, nome apenas por enquanto

  //     for (var informacao in data) {
  //       String nome = informacao['nome'];
  //       nomes.add(nome);
  //       print('Nome: $nome');
  //     }
  //   } catch (e) {
  //     print('Error calling Cloud Function: $e');
  //   }
  // }

  String getCurrentUserId() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      final String uid = user.uid;
      return uid;
    } else {
      return '';
    }
  }

  Future<List<dynamic>> fetchAcceptedBy(String uid) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getAcceptedBy');

    try {
      final result = await callable.call({'uid': uid});
      final List<dynamic> acceptedByList = List.from(result.data);
      return acceptedByList;
    } catch (e) {
      print('Error calling getAcceptedBy function: $e');
      return [];
    }
  }

  void fetchDataAndDisplay() async {
    final uid =
        getCurrentUserId(); // O UID que você deseja passar para a função
    final acceptedByList = await fetchAcceptedBy(uid);

    // Exiba as informações no aplicativo como desejar
    if (acceptedByList.isNotEmpty) {
      acceptedByList.forEach((data) {
        print(data.toString()); // Exemplo de exibição no console
      });
    } else {
      print('Nenhum dado encontrado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBAE8E8),
        title: const Text('OdontApp'),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  fetchDataAndDisplay();
                },
                child: Text('Nome1               5'),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchDataAndDisplay();
                },
                child: Text('Nome2'),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchDataAndDisplay();
                },
                child: Text('Nome3'),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchDataAndDisplay();
                },
                child: Text('Nome4'),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchDataAndDisplay();
                },
                child: Text('Nome5'),
              ),
            ],
          );
        },
      ),
    );
  }
}
