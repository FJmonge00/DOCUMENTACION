<?php
include("conexion.php");  // Conexion con MariaDB y Base de datos
function consulta($conn,$query){
	$resultado = mysqli_query($conn,$query);
	return $resultado;
}
$res = consulta($conn,"SELECT MAX(id) AS id FROM servicios;");
mysqli_close($conn); //cierra la conexion con MariaDB
?>