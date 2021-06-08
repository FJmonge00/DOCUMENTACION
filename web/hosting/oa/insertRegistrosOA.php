<?php
$app = $_POST["app"];
$version = $_POST["version"];
$cliente = $_POST["cliente"];
$notificar = $_POST["notificar"];
$email = $_POST["email"];
include("conexion.php");
function consulta($conn,$query){
	$resultado = mysqli_query($conn,$query);
	return $resultado;
}
$res = consulta($conn,"INSERT INTO `servicios` (`app`,`version`, `cliente`, `notificar`,`email`) VALUES ('$app','$version', '$cliente','$notificar','$email');");
var_dump($res);
mysqli_close($conn); //cierra la conexion
?>