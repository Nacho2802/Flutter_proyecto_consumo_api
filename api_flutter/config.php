<?php
// config.php

define('DB_SERVER', 'localhost');  // Servidor de base de datos
define('DB_USERNAME', 'root');     // Usuario de MySQL
define('DB_PASSWORD', '');         // Contraseña de MySQL
define('DB_DATABASE', 'flutter_2-2024');  // Nombre de la base de datos

// Conexión a la base de datos
function getDB() {
    $dbConnection = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    if ($dbConnection->connect_error) {
        die("❌ Error en la conexión: " . $dbConnection->connect_error);
    }
    return $dbConnection;
}
?>
