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
      appBar: AppBar(title: const Text('Bienvenidos')),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/descargar.png', width: 150, height: 150),
            const SizedBox(height: 20),
            const Text('Bienvenidos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 10),
            Text('Fecha: $currentDate', style: const TextStyle(fontSize: 16, color: Colors.black54)),
            Text('Hora: $currentTime', style: const TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
