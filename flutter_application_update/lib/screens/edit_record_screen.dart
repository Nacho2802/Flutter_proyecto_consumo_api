import 'package:flutter/material.dart';

// Pantalla de edición de registro
class EditRecordScreen extends StatefulWidget {
  final String id;
  final String currentName;
  final Function(String) onUpdate;

  const EditRecordScreen({
    super.key,
    required this.id,
    required this.currentName,
    required this.onUpdate,
  });

  @override
  _EditRecordScreenState createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    widget.onUpdate(nameController.text); // Llamada a la función de actualización
    Navigator.pop(context); // Volver a la pantalla anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nuevo Nombre"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de listado de registros
class RecordListScreen extends StatefulWidget {
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

  // Función para editar un registro
  void _editRecord(String id, String currentName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecordScreen(
          id: id,
          currentName: currentName,
          onUpdate: (newName) {
            setState(() {
              // Actualiza el nombre del registro en la lista
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
            crossAxisCount: 2, // 2 columnas en la cuadrícula
            childAspectRatio: 2.5, // Relación de aspecto para la altura y el ancho de cada tarjeta
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
                    // Llama a la función de editar cuando el icono es presionado
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
