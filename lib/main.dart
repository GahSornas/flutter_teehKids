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
import 'package:pi3_flutter_1/widgets/attachment2.dart';
import 'package:pi3_flutter_1/widgets/attachment3.dart';
import 'package:pi3_flutter_1/widgets/notification.dart';
import 'package:pi3_flutter_1/wait_page.dart';

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
      title: 'OdontApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFBAE8E8)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'OdontApp'),
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
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
  }
//foto
  File pic = File('assets/images/default_camera.png');
  File pic3 = File('assets/images/default_camera.png');
  File pic2 = File('assets/images/default_camera.png');

  showPreview(file) async {
    file = await Get.to(() => PreviewPage(file: file));
    if (file != null) {
      setState(() {
        pic = file;
        Get.back();
      });
    }
  }

  showPreview2(file) async {
    file = await Get.to(() => PreviewPage(file: file));
    if (file != null) {
      setState(() {
        pic2 = file;
        Get.back();
      });
    }
  }

  showPreview3(file) async {
    file = await Get.to(() => PreviewPage(file: file));
    if (file != null) {
      setState(() {
        pic3 = file;
        Get.back();
      });
    }
  }

  //Function para enviar informações para o firestorage
  Future<void> launchInfoHelp(
      String name, String tel, String path1, String path2, String path3) async {
    if (pic != File('assets/images/default_camera.png')) {
      String fcmToken = await notificationServices.getDeviceToken();
      User? user = (await auth.signInAnonymously()).user!;

      File file1 = File(path1);
      File file2 = File(path2);
      File file3 = File(path3);

      try {
        String ref1 = 'emergencias/2/img1-$name-${user.uid}.jpeg';
        await storage.ref(ref1).putFile(file1);
      } on FirebaseException catch (e) {
        throw Exception(('Erro no upload: ${e.code}'));
      }
      try {
        String ref2 = 'emergencias/2/img2-$name-${user.uid}.jpeg';
        await storage.ref(ref2).putFile(file2);
      } on FirebaseException catch (e) {
        throw Exception(('Erro no upload: ${e.code}'));
      }
      try {
        String ref3 = 'emergencias/2/img3-$name-${user.uid}.jpeg';
        await storage.ref(ref3).putFile(file3);
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
            'ImageRoot1': 'emergencias/2/img1-$name-${user.uid}.jpeg',
            'ImageRoot2': 'emergencias/2/img2-$name-${user.uid}.jpeg',
            'ImageRoot3': 'emergencias/2/img3-$name-${user.uid}.jpeg',
          })
          .then((value) => debugPrint("Enviado com Sucesso!!"))
          .catchError((error) => debugPrint("Erro ao adicionar: $error"));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TopBar
      appBar: AppBar(
        backgroundColor: Color(0xFFB8D5F5),
        centerTitle: true,
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
                    left: 20.0, right: 20, top: 10, bottom: 5),
                child: TextFormField(
                  keyboardType: TextInputType.number,
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
              Row(
                children: [
                  Attachment(pic: pic),
                  ElevatedButton.icon(
                    onPressed: () => Get.to(
                      () => CameraCamera(onFile: (pic) => showPreview(pic)),
                    ),
                    icon: const Icon(Icons.camera_alt),
                    label: const Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Text('Boca da criança'),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Attachment2(pic2: pic2),
                  ElevatedButton.icon(
                    onPressed: () => Get.to(
                      () => CameraCamera(onFile: (pic2) => showPreview2(pic2)),
                    ),
                    icon: const Icon(Icons.camera_alt),
                    label: const Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Text('Selfie com a criança'),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Attachment3(pic3: pic3),
                ElevatedButton.icon(
                  onPressed: () => Get.to(
                    () => CameraCamera(onFile: (pic3) => showPreview3(pic3)),
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Text('Documento do responsável'),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ]),

              //btn gravar dados
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      launchInfoHelp(nameController.text, foneController.text,
                          pic.path, pic2.path, pic3.path);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimerScreen(),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gravando dados no Firestore...'),
                        ),
                      );
                    }
                  },
                  child: const Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
