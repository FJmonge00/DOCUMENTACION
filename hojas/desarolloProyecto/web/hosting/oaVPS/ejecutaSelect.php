<?php
include("conexion.php"); // Conexion con MariaDB y la base de datos
//Devuelve todos los registros de una tabla
function consulta($conn,$query){
	$resultado = mysqli_query($conn,$query);
	return $resultado;
}
$res = consulta($conn,"SELECT * FROM vps");
mysqli_close($conn); //cierra la conexion con MariaDB
?>