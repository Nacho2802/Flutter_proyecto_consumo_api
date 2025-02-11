import 'package:flutter/material.dart';
import 'edit_record_screen.dart';

class RecordListScreen extends StatefulWidget {
  const RecordListScreen({super.key});

  @override
  _RecordListScreenState createState() => _RecordListScreenState();
}

class _RecordListScreenState extends State<RecordListScreen> {
  List<Map<String, String>> records = [
    {'id': '1', 'nombre': 'Registro 1'},
    {'id': '2', 'nombre': 'Registro 2'},
    {'id': '3', 'nombre': 'Registro 3'},
    {'id': '4', 'nombre': 'Registro 4'},
  ];

  void _editRecord(String id, String currentName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecordScreen(
          id: id,
          currentName: currentName,
          onUpdate: (newName) {
            setState(() {
              int index = records.indexWhere((record) => record['id'] == id);
              if (index != -1) {
                records[index]['nombre'] = newName;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listado de Registros')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columnas
            childAspectRatio: 2.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: records.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              child: ListTile(
                title: Text(records[index]['nombre']!),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _editRecord(records[index]['id']!, records[index]['nombre']!);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
