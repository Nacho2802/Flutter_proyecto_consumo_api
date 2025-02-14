import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_update/models/producto.dart';
import 'package:flutter_application_update/screens/edit_record_screen.dart';
import 'dart:async';
import 'package:logger/logger.dart';

class RecordListScreen extends StatefulWidget {
  const RecordListScreen({super.key});

  @override
  _RecordListScreenState createState() => _RecordListScreenState();
}

class _RecordListScreenState extends State<RecordListScreen> {
  List<Producto> productos = [];

  @override
  void initState() {
    super.initState();
    _fetchProductos();
  }

  double _convertToDouble(dynamic value) {
    try {
      if (value == null || value.toString().isEmpty) return 0.0;
      return double.tryParse(value.toString()) ?? 0.0;
    } catch (e) {
      print("Error al convertir a double: $e");
      return 0.0;
    }
  }

  Future<void> _fetchProductos() async {
    var logger = Logger();
    try {
      final response = await http.get(Uri.parse('http://localhost/api_flutter/index.php')) 
          .timeout(const Duration(seconds: 10));
      logger.d('Respuesta de la API: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        List<Producto> fetchedProductos = [];
        for (var item in data) {
          // Verificación de todos los campos relevantes
          if (item['codigo'] != null && item['nombre'] != null && item['cantidad'] != null && item['precio'] != null && item['impuesto'] != null) {
            fetchedProductos.add(Producto.fromJson({
              'codigo': item['codigo'],
              'nombre': item['nombre'],
              'descripcion': item['descripcion'] ?? '',
              'cantidad': _convertToDouble(item['cantidad']),
              'precio': _convertToDouble(item['precio']),
              'impuesto': _convertToDouble(item['impuesto']),
            }));
          } else {
            print('Producto con datos faltantes o inválidos: $item');
          }
        }

        setState(() {
          productos = fetchedProductos;
        });
      } else {
        throw Exception('Error al cargar los productos');
      }
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tiempo de espera agotado.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Función para actualizar un producto en la lista
  void _updateProductInList(String codigo, String newName, String newDescription, double newPrice, int newQuantity, double newTax) {
    setState(() {
      int index = productos.indexWhere((prod) => prod.codigo == codigo);
      if (index != -1) {
        productos[index] = Producto(
          codigo: codigo,
          nombre: newName,
          descripcion: newDescription,
          cantidad: newQuantity.toDouble(),
          precio: newPrice,
          impuesto: newTax,
        );
        print("Producto actualizado: ${productos[index].codigo}");
      } else {
        print("Producto con código $codigo no encontrado para actualizar.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listado de Productos')),
      body: productos.isEmpty
          ? const Center(child: CircularProgressIndicator())
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
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditRecordScreen(
                              id: productos[index].codigo,
                              currentName: productos[index].nombre,
                              currentDescription: productos[index].descripcion,
                              currentPrice: productos[index].precio,
                              currentQuantity: productos[index].cantidad.toInt(),
                              currentTax: productos[index].impuesto,
                              onUpdate: (newName, newDescription, newPrice, newQuantity, newTax) {
                                _updateProductInList(productos[index].codigo, newName, newDescription, newPrice, newQuantity, newTax);
                              },
                            ),
                          ),
                        );

                        // Si la pantalla de edición devuelve 'true', recargar la lista
                        if (result == true) {
                          _fetchProductos();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
