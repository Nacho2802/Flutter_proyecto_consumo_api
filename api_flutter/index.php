<?php 
// Habilitar CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Max-Age: 86400");
header("Content-Type: application/json");

// Manejar preflight CORS para solicitudes OPTIONS
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    header("Content-Length: 0");
    header("Content-Type: text/plain");
    exit();
}


require_once 'producto.php';

// Comprobar el método de la solicitud
$method = $_SERVER['REQUEST_METHOD'];
error_log("[DEBUG] Método recibido: " . $_SERVER['REQUEST_METHOD']);
error_log("[DEBUG] JSON recibido: " . file_get_contents("php://input"));

switch ($method) {
    case 'GET':
        $productos = getProductos();
        echo json_encode($productos);
        die(); 

    case 'PUT':
        error_log("📌 [PUT] Recibida solicitud de actualización."); // Debug log

        $inputJSON = file_get_contents('php://input');
        error_log("📌 [PUT] JSON recibido: " . $inputJSON); // Log del JSON recibido

        $data = json_decode($inputJSON, true);

        if (!$data) {
            http_response_code(400);
            echo json_encode(["message" => "Error: No se recibieron datos"]);
            die(); 
        }

        $codigo = $data['codigo'] ?? null;
        $nombre = $data['nombre'] ?? null;
        $descripcion = $data['descripcion'] ?? null;
        $cantidad = $data['cantidad'] ?? null;
        $precio = $data['precio'] ?? null;
        $impuesto = $data['impuesto'] ?? null;

        if (!$codigo || !$nombre || !$descripcion || !$cantidad || !$precio || !$impuesto) {
            http_response_code(400);
            echo json_encode(["message" => "Error: Datos incompletos"]);
            die();
        }

        error_log("📌 [PUT] Datos procesados: Código: $codigo, Nombre: $nombre");

        // Llamar a la función de actualización
        $updateResult = updateProducto($codigo, $nombre, $descripcion, $cantidad, $precio, $impuesto);

        error_log("📌 [PUT] Resultado de updateProducto: " . json_encode($updateResult)); // Log resultado

        if ($updateResult) {
            http_response_code(200);
            echo json_encode(["message" => "Producto actualizado correctamente"]);
            die();
        } else {
            http_response_code(500);
            echo json_encode(["message" => "Error al actualizar el producto"]);
            die();
        }

    default:
        http_response_code(405);
        echo json_encode(["message" => "Método no permitido"]);
        die();
}

?>
