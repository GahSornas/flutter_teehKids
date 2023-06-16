import 'package:flutter/material.dart';
import 'package:pi3_flutter_1/emergency_page.dart';
import 'package:timer_builder/timer_builder.dart';
import 'emergency_page.dart';


class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _secondsRemaining = 20;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: _secondsRemaining), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmergenciesPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Screen'),
      ),
      body: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
        if (_secondsRemaining <= 0) {
          return Center(
            child: CircularProgressIndicator(), // Exibir um indicador de progresso enquanto a tela é trocada
          );
        } else {
          _secondsRemaining--;
          return Center(
            child: Image.asset(
              'assets/images/loading.gif',
              fit: BoxFit.contain,
            ),
          );
        }
      }),
    );
  }
}