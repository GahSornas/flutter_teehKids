import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB8D5F5),
        centerTitle: true,
        title: Text(
          'OdontApp',
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Seja bem-vindo',
              style: TextStyle(
                fontSize: 50,
                color: Color(0xFF272643),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Somos a OdontApp, promovendo o cuidado odontológico infantil com amor e agilidade.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF272643),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {}, // Ação do botão
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF8E8E),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Solicitar emergência',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
