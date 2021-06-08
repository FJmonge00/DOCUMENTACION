<?php
//Recogida de variables
$identificador =$_POST["identificador"]; // Formulario
include("conexion.php");  // Conexion con MariaDB y Base de datos
function consulta($conn,$query){
	$resultado = mysqli_query($conn,$query);
	return $resultado;
}
$res = consulta($conn,"SELECT * FROM vps WHERE id='$identificador'");
mysqli_close($conn); //cierra la conexion con MariaDB
?>