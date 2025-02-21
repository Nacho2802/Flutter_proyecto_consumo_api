import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'delete_product_screen.dart'; // Asegúrate de que esta ruta sea correcta

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  // Función para obtener los registros desde la API
  Future<void> _fetchRecords() async {
    final url = Uri.parse('http://192.168.1.9/api_flutter/index.php');
    try {
      final response = await http.get(url);
      print('Respuesta de la API: ${response.body}');
      
      // Verifica si la respuesta contiene una lista de registros.
      if (response.statusCode == 200) {
        // Intenta decodificar la respuesta
        try {
          final List<dynamic> data = jsonDecode(response.body);
          setState(() {
            records = List<Map<String, dynamic>>.from(data);
          });
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

  // Función para eliminar un registro
  Future<void> _deleteRecord(Map<String, dynamic> product) async {
    final String id = product['id'];  // Obtén el ID del producto
    final url = Uri.parse('http://192.168.1.9/api_flutter/product.php');  // Ajusta la URL según la ruta de eliminación
    
    try {
      final response = await http.post(
        url,
        body: {'id': id},  // Enviar el id del producto a eliminar
      );
      print('Respuesta de eliminación: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          // Si la eliminación fue exitosa, eliminamos el producto de la lista localmente
          setState(() {
            records.removeWhere((record) => record['id'] == id);
          });
          _showError('Producto eliminado con éxito');
        } else {
          _showError('Error al eliminar el producto');
        }
      } else {
        _showError('Error al conectar con el servidor');
      }
    } catch (error) {
      _showError('Error al intentar eliminar: $error');
    }
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
          appBar: AppBar(
            title: const Text('Listado de Productos'),
            backgroundColor: Colors.indigo,  // Color diferente en el AppBar
          ),
          backgroundColor: Colors.grey[200],  // Fondo gris claro para diferenciarlo
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: records.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        color: Colors.white, // Fondo diferente al de la pantalla de actualización
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.indigo, width: 1.5), // Borde para destacar
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(bottom: 12), 
                        child: Padding(
                          padding: const EdgeInsets.all(20.0), // Más espaciamiento para mejor visualización
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      records[index]['nombre'],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87, // Texto más oscuro
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Código: ${records[index]['codigo']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.indigo[700], // Color diferente para destacar
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 32),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DeleteProductScreen(
                                        product: records[index],
                                        onDelete: _deleteRecord,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      }
   }