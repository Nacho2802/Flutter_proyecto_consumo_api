import 'dart:convert';
import 'package:http/http.dart' as http;

class Producto {
  final String codigo;
  final String nombre;
  final String descripcion;
  final double cantidad;
  final double precio;
  final double impuesto;

  Producto({
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.cantidad,
    required this.precio,
    required this.impuesto,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      codigo: json['codigo'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      cantidad: json['cantidad'].toDouble(),
      precio: json['precio'].toDouble(),
      impuesto: json['impuesto'].toDouble(),
    );
  }
}




// Función para obtener la lista de productos desde la API
Future<List<Producto>> fetchProductos() async {
  final response = await http.get(Uri.parse('http://localhost/api_flutter/producto.php'));

  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, parseamos la respuesta JSON
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Producto.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load productos');
  }
}
