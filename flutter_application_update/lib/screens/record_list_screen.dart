import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para convertir el JSON
import 'package:flutter_application_update/models/producto.dart'; // Asegúrate de importar la clase Producto
import 'package:flutter_application_update/screens/edit_record_screen.dart'; // Ajusta la ruta según tu estructura
import 'dart:async'; 


class RecordListScreen extends StatefulWidget {
  const RecordListScreen({super.key});

  @override
  _RecordListScreenState createState() => _RecordListScreenState();
}

class _RecordListScreenState extends State<RecordListScreen> {
  // Lista de productos que se llenará con la respuesta de la API
  List<Producto> productos = [];

  @override
  void initState() {
    super.initState();
    _fetchProductos(); // Llamamos a la función para obtener los productos desde la API
  }

  // Función para obtener los productos desde la API
  Future<void> _fetchProductos() async {
  try {
    final response = await http
        .get(Uri.parse('http://localhost/api_flutter/'))
        .timeout(const Duration(seconds: 10)); // Tiempo máximo de espera

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        productos = data.map((producto) => Producto.fromJson(producto)).toList();
      });
    } else {
      throw Exception('Error al cargar los productos');
    }
  } on TimeoutException {
    print("Error: Tiempo de espera agotado.");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tiempo de espera agotado."))
    );
  } catch (e) {
    print("Error: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listado de Productos')),
      body: productos.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Muestra el indicador de carga si no hay productos
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text(productos[index].nombre),
                    subtitle: Text('Precio: ${productos[index].precio}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Aquí podrías agregar la funcionalidad de edición si es necesario
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
