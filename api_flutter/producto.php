<?php
// producto.php

require_once 'config.php';

// Obtener todos los productos
function getProductos() {
    $db = getDB();
    $sql = "SELECT * FROM productos";  
    $result = $db->query($sql);
    
    $productos = [];
    while ($row = $result->fetch_assoc()) {
        $productos[] = $row;
    }
    
    return $productos;
}

function updateProducto($codigo, $nombre, $descripcion, $cantidad, $precio, $impuesto) {
    $db = getDB();

    // Validación de datos numéricos
    $cantidad = is_numeric($cantidad) ? (float)$cantidad : 0;
    $precio = is_numeric($precio) ? (float)$precio : 0;
    $impuesto = is_numeric($impuesto) ? (float)$impuesto : 0;

    // Preparar la consulta de actualización
    $stmt = $db->prepare("UPDATE productos SET nombre = ?, descripcion = ?, cantidad = ?, precio = ?, impuesto = ? WHERE codigo = ?");

    if (!$stmt) {
        error_log("⚠️ Error en prepare(): " . $db->error);
        echo json_encode(["message" => "Error al preparar la consulta"]);
        return false;
    }

    $stmt->bind_param("ssddds", $nombre, $descripcion, $cantidad, $precio, $impuesto, $codigo);

    // Ejecutar la consulta y manejar el resultado
    if (!$stmt->execute()) {
        error_log("⚠️ Error en execute(): " . $stmt->error);
        echo json_encode(["message" => "Error al ejecutar la consulta"]);
        return false;
    }

    if ($stmt->affected_rows > 0) {
        echo json_encode(["message" => "Producto actualizado correctamente"]);
    } else {
        error_log("⚠️ No se actualizó ninguna fila. Verifica si el código existe.");
        echo json_encode(["message" => "No se realizaron cambios en el producto"]);
    }

    return true;
}

?>
