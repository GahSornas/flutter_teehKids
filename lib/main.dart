import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// firebase
// import 'firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';

// firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pi3_flutter_1/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFBAE8E8)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TeehKids'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //TextFieldControler
  final nameController = TextEditingController();
  final foneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //Referência ao firebase
  CollectionReference infoHelp =
      FirebaseFirestore.instance.collection('infoHelp');

  //Function para enviar informações para o firebase
  Future<void> launchInfoHelp(String name, String tel) {
    return infoHelp
        .add({
          'nome': name,
          'telefone': tel,
        })
        .then((value) => debugPrint("Enviado com Sucesso!!"))
        .catchError((error) => debugPrint("Erro ao adicionar: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TopBar
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Label do nome
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle),
                  hintText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe um nome';
                  }
                  return null;
                },
              ),
            ),

            //Label do telefone
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.call),
                  hintText: 'Telefone',
                  border: OutlineInputBorder(),
                ),
                controller: foneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe um telefone';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    launchInfoHelp(nameController.text, foneController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Gravando dados no Firestore...')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
