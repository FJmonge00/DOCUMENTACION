<?php
include("conexion.php"); # Conexion a la base de datos
//Devuelve todos los registros de una tabla
function consulta($conn,$query){
	$resultado = mysqli_query($conn,$query);
	return $resultado;
}
$res = consulta($conn,"SELECT * FROM servicios");
mysqli_close($conn); //cierra la conexion con MariaDB
?>