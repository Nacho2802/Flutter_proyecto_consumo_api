<?php
// Habilitar CORS
header("Access-Control-Allow-Origin: *");  // Permite cualquier origen
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");  // Métodos permitidos
header("Access-Control-Allow-Headers: Content-Type, Authorization");  // Encabezados permitidos

header("Content-Type: application/json");  // Establecer el tipo de respuesta a JSON
require_once 'producto.php';

// Comprobar el método de la solicitud
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // Obtener productos
        $productos = getProductos();
        echo json_encode($productos);
        break;

    case 'PUT':
        // Actualizar producto
        $data = json_decode(file_get_contents('php://input'), true);
        $codigo = $data['codigo'];
        $nombre = $data['nombre'];
        $descripcion = $data['descripcion'];
        $cantidad = $data['cantidad'];
        $precio = $data['precio'];
        $impuesto = $data['impuesto'];

        if (updateProducto($codigo, $nombre, $descripcion, $cantidad, $precio, $impuesto)) {
            echo json_encode(["message" => "Producto actualizado correctamente"]);
        } else {
            echo json_encode(["message" => "Error al actualizar el producto"]);
        }
        break;

    default:
        echo json_encode(["message" => "Método no permitido"]);
        break;
}
?>
