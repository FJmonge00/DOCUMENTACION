<?php
$so = $_POST["so"];
$plan = $_POST["plan"];
$cliente = $_POST["cliente"];
$vcpu = $_POST["vcpu"];
$vram = $_POST["vram"];
$disco = $_POST["disco"];
$notificar = $_POST["notificar"];
$email = $_POST["email"];
include("conexion.php");
function consulta($conn,$query){
	$resultado = mysqli_query($conn,$query);
	return $resultado;
}
$res = consulta($conn,"INSERT INTO `vps` (`so`,`plan`,`cliente`,`vcpu`,`vram`,`disco`,`notificar`,`email`) VALUES ('$so','$plan','$cliente','$vcpu','$vram','$disco','$notificar','$email');");
var_dump($res);
mysqli_close($conn); //cierra la conexion
?>