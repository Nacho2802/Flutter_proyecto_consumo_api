<?php
// index.php

require_once 'config.php';  // Incluir la configuración de la base de datos

// FUNCIÓN PARA OBTENER TODOS LOS PRODUCTOS
function getProductos() {
    $db = getDB();  // Obtener la conexión a la base de datos

    // Consulta para obtener todos los productos
    $query = "SELECT * FROM productos";  // Asegúrate de que la tabla 'productos' exista
    $result = $db->query($query);

    if ($result->num_rows > 0) {
        $productos = [];
        while ($row = $result->fetch_assoc()) {
            $productos[] = $row;
        }
        return $productos;  // Retornar todos los productos
    } else {
        return [];  // Retornar un array vacío si no hay productos
    }

    $db->close();  // Cerrar la conexión
}

// FUNCIÓN PARA CREAR UN PRODUCTO
function createProducto($codigo, $nombre, $descripcion, $cantidad, $precio, $impuesto) {
    $db = getDB();  // Obtener la conexión a la base de datos

    // Sanitizar los datos para evitar inyecciones SQL
    $codigo = $db->real_escape_string($codigo);
    $nombre = $db->real_escape_string($nombre);
    $descripcion = $db->real_escape_string($descripcion);
    $cantidad = is_numeric($cantidad) ? (float)$cantidad : 0;
    $precio = is_numeric($precio) ? (float)$precio : 0;
    $impuesto = is_numeric($impuesto) ? (float)$impuesto : 0;

    // Verificar si el código ya existe
    $checkQuery = "SELECT * FROM productos WHERE codigo = '$codigo'";
    $checkResult = $db->query($checkQuery);

    if ($checkResult->num_rows > 0) {
        echo json_encode(["success" => false, "message" => "El código ya existe"]);
        return;
    }

    // Insertar un nuevo producto
    $stmt = $db->prepare("INSERT INTO productos (codigo, nombre, descripcion, cantidad, precio, impuesto) VALUES (?, ?, ?, ?, ?, ?)");
    if (!$stmt) {
        echo json_encode(["success" => false, "message" => "Error al preparar la consulta"]);
        return;
    }

    $stmt->bind_param("sssddd", $codigo, $nombre, $descripcion, $cantidad, $precio, $impuesto);

    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "Producto agregado correctamente"]);
    } else {
        echo json_encode(["success" => false, "message" => "Error al agregar producto"]);
    }
    $stmt->close();
}

// Manejo de las solicitudes
$method = $_SERVER['REQUEST_METHOD'];

// Habilitar CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

// Manejo de solicitudes GET (Obtener productos)
if ($method === 'GET') {
    $productos = getProductos();
    echo json_encode($productos);
}

// Manejo de solicitudes POST (Crear producto)
if ($method === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    if (isset($data['codigo'], $data['nombre'], $data['descripcion'], $data['cantidad'], $data['precio'], $data['impuesto'])) {
        createProducto($data['codigo'], $data['nombre'], $data['descripcion'], $data['cantidad'], $data['precio'], $data['impuesto']);
    } else {
        echo json_encode(["success" => false, "message" => "Datos incompletos"]);
    }
}

?>
