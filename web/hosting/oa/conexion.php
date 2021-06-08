<?php
function conexion(){
   if (!($conn=mysqli_connect("localhost","zeus","Coria21")))
   {
      echo "Error al conectar con MariaDB.";
      exit();
   }
   if (!mysqli_select_db($conn,"hosting"))
   {
      echo "Error al conectarse a la base de datos hosting.";
      exit();
   }
   return $conn;
}
$conn=conexion();
?>