import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'record_list_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late String currentDate;
  late String currentTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _updateDateTime();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _updateDateTime();
    });
  }

  void _updateDateTime() {
    if (!mounted) return;
    setState(() {
      currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenidos'), backgroundColor: Colors.deepPurple),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Menú Principal',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Registros'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecordListScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/descargar.png', width: 150, height: 150),
              const SizedBox(height: 20),
              const Text(
                'Bienvenidos',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 10),
              Text(
                'Fecha: $currentDate',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              Text(
                'Hora: $currentTime',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              // Sección de integrantes del equipo
              const Text(
                'Integrantes del equipo:',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 10),
              const Text(
                '• Ignacio Pérez',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const Text(
                '• Roberto Quintero',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const Text(
                '• David Mendoza',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const Text(
                '• Jose Franco',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
