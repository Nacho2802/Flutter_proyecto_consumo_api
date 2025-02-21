import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_update/screens/welcome_screen.dart';

class DeleteProductScreen extends StatelessWidget {
  final Map<String, dynamic> product; // Recibimos el producto completo
  final Function(Map<String, dynamic>) onDelete; // Función para eliminar el producto

  const DeleteProductScreen({
    Key? key,
    required this.product,   // Recibimos el objeto producto
    required this.onDelete,  // Recibimos la función onDelete
  }) : super(key: key);

  Future<void> _deleteProduct(BuildContext context) async {
    final url = Uri.parse('http://192.168.1.9/api_flutter/product.php'); // Usa la URL correcta

    try {
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "codigo": product['codigo'],  // Usamos el código o identificador
        }),
      );
      print('Respuesta de eliminación: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] != null && data['success'] == true) {
          // Eliminación exitosa, llamamos la función onDelete para actualizar el listado
          onDelete(product);  // Pasamos todo el producto para eliminarlo de la lista

          // Muestra un mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto eliminado correctamente'),
              duration: Duration(seconds: 2),
            ),
          );

          // Redirige a WelcomeScreen sin necesidad de Future.delayed
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
            (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
          );
        } else {
          // En caso de error en la respuesta del servidor
          _showError(context, data['error'] ?? 'Error al eliminar el producto');
        }
      } else {
        // Si el servidor devuelve un error HTTP
        _showError(context, 'Error al conectar con el servidor: ${response.statusCode}');
      }
    } catch (error) {
      // Capturamos cualquier error inesperado
      _showError(context, 'Error al intentar eliminar: $error');
    }
  }

  // Función para mostrar el mensaje de error
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning, color: Colors.red, size: 80), // Ícono de advertencia
            const SizedBox(height: 20),
            Text(
              "Estás a punto de eliminar el producto:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              product['nombre'], // Usamos el nombre del producto
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _deleteProduct(context), // Llamamos la función de eliminación
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Eliminar Producto", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
