<?php
// producto.php

require_once 'config.php';

// Obtener todos los productos
function getProductos() {
    $db = getDB();
    $sql = "SELECT * FROM productos";  // Asumiendo que tu tabla se llama producto
    $result = $db->query($sql);
    
    $productos = [];
    while ($row = $result->fetch_assoc()) {
        $productos[] = $row;
    }
    
    return $productos;
}

// Actualizar un producto
function updateProducto($codigo, $nombre, $descripcion, $cantidad, $precio, $impuesto) {
    $db = getDB();
    $stmt = $db->prepare("UPDATE productos SET nombre = ?, descripcion = ?, cantidad = ?, precio = ?, impuesto = ? WHERE codigo = ?");
    $stmt->bind_param("sssdsd", $nombre, $descripcion, $cantidad, $precio, $impuesto, $codigo);
    $stmt->execute();
    return $stmt->affected_rows > 0;
}
?>
