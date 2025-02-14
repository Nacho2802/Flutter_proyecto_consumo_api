import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edit_record_screen.dart';

class RecordListScreen extends StatefulWidget {
  const RecordListScreen({super.key});

  @override
  _RecordListScreenState createState() => _RecordListScreenState();
}

class _RecordListScreenState extends State<RecordListScreen> {
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  // Función para obtener los registros desde la API
  Future<void> _fetchRecords() async {
  final url = Uri.parse('http://localhost/api_flutter/get_records.php/');
  try {
    final response = await http.get(url);
    print('Respuesta de la API: ${response.body}');
    
    // Verifica si la respuesta contiene un JSON válido.
    if (response.statusCode == 200) {
      // Si la respuesta es válida, intenta decodificar el JSON.
      try {
        final data = jsonDecode(response.body);
        // Asegúrate de que la respuesta contiene la clave 'records'.
        if (data.containsKey('records')) {
          setState(() {
            records = List<Map<String, dynamic>>.from(data['records']);
          });
        } else {
          _showError('Formato de respuesta incorrecto.');
        }
      } catch (e) {
        _showError('Error al parsear JSON: $e');
      }
    } else {
      _showError('Error al obtener los registros. Código: ${response.statusCode}');
    }
  } catch (error) {
    _showError('Error en la solicitud: $error');
  }
}


  // Función para editar un registro
  void _editRecord(String id, String currentName, double currentPrice, int currentQuantity, double currentTax) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecordScreen(
          id: id,  
          currentName: currentName,
          currentDescription: currentName,  // Ajuste aquí si se requiere descripción
          currentPrice: currentPrice,
          currentQuantity: currentQuantity,
          currentTax: currentTax,
          onUpdate: (newName, newDescription, newPrice, newQuantity, newTax) {
            setState(() {
              int index = records.indexWhere((record) => record['id'] == id);
              if (index != -1) {
                // Actualizando los valores del registro
                records[index]['nombre'] = newName;
                records[index]['descripcion'] = newDescription;
                records[index]['precio'] = newPrice;
                records[index]['cantidad'] = newQuantity;
                records[index]['impuesto'] = newTax;
              }
            });
          },
        ),
      ),
    );
  }

  // Función para mostrar el mensaje de error
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listado de Registros')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: records.isEmpty
            ? const Center(child: CircularProgressIndicator())  // Cargar spinner mientras no hay registros
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(records[index]['nombre']),
                      subtitle: Text('Precio: \$${records[index]['precio']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editRecord(
                            records[index]['id'],
                            records[index]['nombre'],
                            records[index]['precio'].toDouble(),
                            records[index]['cantidad'],
                            records[index]['impuesto'].toDouble(),
                          );
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
