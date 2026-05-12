<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$csvDir = __DIR__ . '/files/CSV';
$csvFiles = glob($csvDir . '/*.csv');
$importados = [];
$errores = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['importar'])) {
    // Conexión a BD
    $mysqli = new mysqli('localhost', 'root', 'Root', 'glpi');
    if ($mysqli->connect_error) {
        $errores[] = 'Error de conexión: ' . $mysqli->connect_error;
    } else {
        $mysqli->set_charset("utf8mb4");
        
        foreach ($csvFiles as $csvFile) {
            $fileName = basename($csvFile);
            $handle = fopen($csvFile, 'r');
            if (!$handle) continue;
            
            $encabezados = fgetcsv($handle);
            $contador = 0;
            
            while (($fila = fgetcsv($handle)) !== false) {
                $registro = array_combine($encabezados, $fila);
                
                $nombre = isset($registro['NOMBRE DEL EQUIPO']) ? trim($registro['NOMBRE DEL EQUIPO']) : '';
                $serial = isset($registro['N/S']) ? trim($registro['N/S']) : '';
                $modelo = isset($registro['MODELO']) ? trim($registro['MODELO']) : '';
                
                if (empty($nombre)) continue;
                
                $nombre = $mysqli->real_escape_string($nombre);
                $serial = $mysqli->real_escape_string($serial);
                $modelo = $mysqli->real_escape_string($modelo);
                
                $sql = "INSERT INTO glpi_computers (name, serial, model, users_id, groups_id, states_id, date_mod, date_creation) 
                        VALUES ('$nombre', '$serial', '$modelo', 0, 0, 1, NOW(), NOW())";
                
                if ($mysqli->query($sql)) {
                    $contador++;
                }
            }
            
            fclose($handle);
            $importados[$fileName] = $contador;
        }
        
        $mysqli->close();
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Importador GLPI</title>
    <style>
        body { font-family: Arial; margin: 20px; background: #f5f5f5; }
        .container { max-width: 900px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; }
        h1 { color: #333; }
        .info { background: #e7f3ff; padding: 15px; border-radius: 4px; border-left: 4px solid #007bff; margin: 15px 0; }
        .success { background: #d4edda; padding: 15px; border-radius: 4px; border-left: 4px solid #28a745; margin: 15px 0; }
        .file-item { background: #f9f9f9; padding: 10px; margin: 10px 0; border-radius: 4px; }
        button { background: #007bff; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; }
        button:hover { background: #0056b3; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
    </style>
</head>
<body>
<div class="container">
    <h1>📁 Importador de Inventario GLPI</h1>
    
    <div class="info">
        Archivos CSV encontrados: <strong><?php echo count($csvFiles); ?></strong>
    </div>
    
    <?php foreach ($csvFiles as $archivo): ?>
        <div class="file-item">✓ <?php echo basename($archivo); ?></div>
    <?php endforeach; ?>
    
    <?php if (!empty($importados)): ?>
        <div class="success">
            <h2>✅ Importación completada</h2>
            <table>
                <tr><th>Archivo</th><th>Equipos importados</th></tr>
                <?php foreach ($importados as $archivo => $cantidad): ?>
                    <tr><td><?php echo htmlspecialchars($archivo); ?></td><td><?php echo $cantidad; ?></td></tr>
                <?php endforeach; ?>
            </table>
            <p><strong>Total: <?php echo array_sum($importados); ?> equipos</strong></p>
        </div>
    <?php else: ?>
        <form method="POST" style="margin-top: 20px;">
            <button type="submit" name="importar" value="1" onclick="return confirm('¿Importar todos los equipos?')">
                🚀 Importar CSV ahora
            </button>
        </form>
    <?php endif; ?>
</div>
</body>
</html>
