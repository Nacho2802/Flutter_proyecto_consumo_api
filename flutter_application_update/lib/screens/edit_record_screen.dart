import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'welcome_screen.dart';  


class EditRecordScreen extends StatefulWidget {
  
  final String id;
  final String currentName;
  final String currentDescription;
  final double currentPrice;
  final int currentQuantity;
  final double currentTax;
  final Function(String, String, double, int, double) onUpdate;

  const EditRecordScreen({
    super.key,
    required this.id,
    required this.currentName,
    required this.currentDescription,
    required this.currentPrice,
    required this.currentQuantity,
    required this.currentTax,
    required this.onUpdate,
  });

  @override
  _EditRecordScreenState createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  late TextEditingController taxController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    descriptionController = TextEditingController(text: widget.currentDescription);
    priceController = TextEditingController(text: widget.currentPrice.toString());
    quantityController = TextEditingController(text: widget.currentQuantity.toString());
    taxController = TextEditingController(text: widget.currentTax.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    taxController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        quantityController.text.isEmpty ||
        taxController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, completa todos los campos.")),
      );
      return;
    }

    final url = Uri.parse('http://localhost/api_flutter/index.php'); // Cambiar localhost si usas emulador Android

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "codigo": widget.id,
          "nombre": nameController.text.trim(),
          "descripcion": descriptionController.text.trim(),
          "precio": double.tryParse(priceController.text) ?? 0.0,
          "cantidad": double.tryParse(quantityController.text) ?? 0,
          "impuesto": double.tryParse(taxController.text) ?? 0.0,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'] == "Producto actualizado correctamente") {
          widget.onUpdate(
            nameController.text.trim(),
            descriptionController.text.trim(),
            double.parse(priceController.text),
            int.parse(quantityController.text),
            double.parse(taxController.text),
          );

          // Mostrar el mensaje de "DATOS ACTUALIZADOS"
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("DATOS ACTUALIZADOS")),
          );

          // Redirigir a la pantalla principal (WelcomeScreen)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al actualizar: ${data['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error en la respuesta del servidor: ${response.statusCode}")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en la solicitud: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Producto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nuevo Nombre"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Nueva Descripción"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Nuevo Precio"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: "Nueva Cantidad"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: taxController,
              decoration: const InputDecoration(labelText: "Nuevo Impuesto"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProduct,
              child: const Text("Guardar Cambios"),
            ),
          ],
        ),
      ),
    );
  }
}