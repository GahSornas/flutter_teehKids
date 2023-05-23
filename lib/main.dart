import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera_camera/camera_camera.dart';

// firebase
import 'package:firebase_core/firebase_core.dart';

// firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pi3_flutter_1/firebase_options.dart';

// Widgets
import 'package:pi3_flutter_1/preview_page.dart';
import 'package:pi3_flutter_1/widgets/attachment.dart';
import 'package:pi3_flutter_1/widgets/notification.dart';
import 'package:pi3_flutter_1/emergency_page.dart';

// Storage
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';


final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
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
      FirebaseFirestore.instance.collection('emergencias');

  //Notification
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState(){
    super.initState();
    notificationServices.requestNotificationPermission();
  }
  //Function para enviar informações para o firestorage
  Future<void> launchInfoHelp(String name, String tel, String path) async {
    if(pic != File('assets/images/default_camera.png')){

        String fcmToken = await notificationServices.getDeviceToken();
        User? user = (await auth.signInAnonymously()).user!;


        File file = File(path);
        try{
          String ref = 'emergencias/2/img-$name-${user.uid}.jpeg';
          await storage.ref(ref).putFile(file);
        } on FirebaseException catch (e) {
            throw Exception(('Erro no upload: ${e.code}'));
        }

          return infoHelp
            .add({
              'nome': name,
              'telefone': tel,
              'status': 'new',
              'FCMToken': fcmToken,
              'uid': user.uid,
              'ImageRoot': 'emergencias/2/img-$name-${user.uid}.jpeg',
            })
            .then((value) => debugPrint("Enviado com Sucesso!!"))
            .catchError((error) => debugPrint("Erro ao adicionar: $error"));  
      }
  }

  //foto
  File pic = File('assets/images/default_camera.png');

  showPreview(file) async {
    file = await Get.to(() => PreviewPage(file: file));

    if (file != null) {
      setState(() {
        pic = file;
        Get.back();
      });
    }
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //Label do nome
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
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
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, top: 20, bottom: 10),
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

              //botão foto
              ElevatedButton.icon(
                onPressed: () => Get.to(
                  () => CameraCamera(onFile: (pic) => showPreview(pic)),
                ),
                icon: const Icon(Icons.camera_alt),
                label: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Tire uma foto'),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              Attachment(pic: pic),

            //btn gravar dados
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {  
                      if (_formKey.currentState!.validate()) {
                      launchInfoHelp(nameController.text, foneController.text, pic.path);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  EmergenciesPage()),
                      );
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
      ),
    );
  }
}
