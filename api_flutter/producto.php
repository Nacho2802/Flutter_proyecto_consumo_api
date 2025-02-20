<?php
require_once 'config.php';
$db = getDB();

// CREAR PRODUCTO
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $data = json_decode(file_get_contents("php://input"), true);

    if (isset($data['codigo'], $data['nombre'], $data['descripcion'], $data['cantidad'], $data['precio'], $data['impuesto'])) {
        createProducto($data['codigo'], $data['nombre'], $data['descripcion'], $data['cantidad'], $data['precio'], $data['impuesto']);
    } else {
        echo json_encode(["success" => false, "message" => "Datos incompletos"]);
    }
}

// FUNCIÓN PARA CREAR UN PRODUCTO
function createProducto($codigo, $nombre, $descripcion, $cantidad, $precio, $impuesto) {
    global $db;

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

    // Insertar nuevo producto
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

// FUNCIÓN PARA ACTUALIZAR UN PRODUCTO (usada en index.php)
function updateProducto($codigo, $nombre, $descripcion, $cantidad, $precio, $impuesto) {
    global $db;

    $stmt = $db->prepare("UPDATE productos SET nombre = ?, descripcion = ?, cantidad = ?, precio = ?, impuesto = ? WHERE codigo = ?");
    if (!$stmt) {
        return false;
    }

    $stmt->bind_param("ssddds", $nombre, $descripcion, $cantidad, $precio, $impuesto, $codigo);
    $result = $stmt->execute();
    $stmt->close();

    return $result;
}

$db->close();
?>
