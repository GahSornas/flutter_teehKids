import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class User {
  final String name;
  final String photoPath;
  final String information;
  final LatLng location;

  User({
    required this.name,
    required this.photoPath,
    required this.information,
    required this.location,
  });
}

void main() {
  runApp(EmergenciesPage());
}

class EmergenciesPage extends StatelessWidget {
  EmergenciesPage({Key? key}) : super(key: key);

  final List<User> users = [
    User(
      name: 'Jorge Machado',
      photoPath: 'assets/images/jorge.png',
      information: '★ ★ ★ ★ ☆',
      location: LatLng(-23.5505, -46.6333),
    ),
    User(
      name: 'Ana Clara Falcão',
      photoPath: 'assets/images/ana.png',
      information: '★ ★ ★ ☆ ☆',
      location: LatLng(-23.5505, -46.6333),
    ),
    User(
      name: 'Matheus Cavalcante',
      photoPath: 'assets/images/matheus.png',
      information: '★ ★ ★ ☆ ☆',
      location: LatLng(40.7128, -74.0060),
    ),
    User(
      name: 'Rodrigo da Silva',
      photoPath: 'assets/images/rodrigo.png',
      information: '★ ★ ☆ ☆ ☆',
      location: LatLng(-33.8675, 151.2070),
    ),
    User(
      name: 'Marcia Souza',
      photoPath: 'assets/images/marcia.png',
      information: '★ ★ ★ ★ ☆',
      location: LatLng(25.2048, 55.2708),
    ),
  ];

  void openGoogleMaps(LatLng destination) async {
    LocationPermission permission;

    // Verifica a permissão de localização
    if (!await Geolocator.isLocationServiceEnabled()) {
      print('Serviço de localização desabilitado');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        print('Permissão de localização negada');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Permissão de localização negada permanentemente');
      return;
    }

    // Obtém a posição atual
    Position position = await Geolocator.getCurrentPosition();

    // Cria as coordenadas de origem e destino
    LatLng origin = LatLng(position.latitude, position.longitude);

    final url = 'https://www.google.com/maps/dir/?api=1&origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Erro ao abrir o Google Maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFBAE8E8),
          title: const Text('OdontApp'),
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(user.photoPath),
              ),
              title: Text(user.name),
              subtitle: Text(user.information),
              trailing: IconButton(
                icon: Icon(Icons.map),
                onPressed: () => openGoogleMaps(user.location),
              ),
            );
          },
        ),
      ),
    );
  }
}
