<?php
// config.php

define('DB_SERVER', 'localhost');  // o IP de tu servidor de base de datos
define('DB_USERNAME', 'root');     // tu usuario de MySQL
define('DB_PASSWORD', '');         // tu contraseña de MySQL
define('DB_DATABASE', 'productos');  // nombre de tu base de datos

// Conexión a la base de datos
function getDB() {
    $dbConnection = null;
    try {
        $dbConnection = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    } catch (mysqli_sql_exception $e) {
        echo "Connection failed: " . $e->getMessage();
    }
    return $dbConnection;
}
?>
