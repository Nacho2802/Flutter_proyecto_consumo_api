import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'welcome_screen.dart';

class CrearProductoScreen extends StatefulWidget {
  @override
  _CrearProductoScreenState createState() => _CrearProductoScreenState();
}

class _CrearProductoScreenState extends State<CrearProductoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _impuestoController = TextEditingController();


Future<void> crearProducto() async {
  final String apiUrl = "http://192.168.1.9/api_flutter/index.php"; 

  final Map<String, dynamic> productoData = {
    'codigo': _codigoController.text,
    'nombre': _nombreController.text,
    'descripcion': _descripcionController.text,
    'cantidad': _cantidadController.text,
    'precio': _precioController.text,
    'impuesto': _impuestoController.text,
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Content-Type": "application/json"},
    body: json.encode(productoData),
  );

  if (response.statusCode == 200) {
    try {
      // Intentamos parsear la respuesta como JSON
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Verificamos el mensaje recibido en la respuesta
      if (responseData["message"] == "Producto agregado correctamente") {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto registrado exitosamente')));
        
        // Redirigir a la pantalla de bienvenida
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()), // Reemplazar "WelcomeScreen" con el nombre de tu pantalla de bienvenida
        );
      } else {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar el producto')));
      }
    } catch (e) {
      // Si ocurre un error al parsear el JSON
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al procesar la respuesta del servidor')));
    }
  } else {
    // Error de la solicitud
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error en la conexión')));
  }
}



 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Crear Producto"),
      backgroundColor: Colors.teal, // Color más atractivo para el appBar
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView( // Permite el desplazamiento en pantallas más pequeñas
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alineación de los campos
            children: <Widget>[
              TextFormField(
                controller: _codigoController,
                decoration: InputDecoration(
                  labelText: 'Código',
                  labelStyle: TextStyle(color: Colors.teal), // Color del texto de la etiqueta
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal), // Borde al enfocarse
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el código';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10), // Espaciado entre los campos
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: Colors.teal),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  labelStyle: TextStyle(color: Colors.teal),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _cantidadController,
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  labelStyle: TextStyle(color: Colors.teal),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la cantidad';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _precioController,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  labelStyle: TextStyle(color: Colors.teal),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el precio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _impuestoController,
                decoration: InputDecoration(
                  labelText: 'Impuesto',
                  labelStyle: TextStyle(color: Colors.teal),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el impuesto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    crearProducto(); // Llamada para registrar el producto
                  }
                },
                child: Text(
                  'Registrar Producto',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Texto más destacado
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12), // Mayor espacio en el botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Bordes redondeados
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
