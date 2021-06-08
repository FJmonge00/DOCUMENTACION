<html>
	<head>
		<meta charset="UTF-8">
		<title>Busqueda Por id</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<style>
			body {
				background: rgb(23,182,184);
				background: linear-gradient(0deg, rgba(23,182,184,1) 0%, rgba(233,162,9,1) 100%);
				}
			table {
			/* border-collapse: collapse; */
			width: 100%;
			/* border: 2px solid black; */
			}
			tr {
				border: 2px solid black; 
				background: white;
			}
			h2 {
				text-align: center
			}
			th, td {
			text-align: center;
			padding: 10px
			}
			tr:nth-child(even) {background-color: #AED6F1;}
		</style>
	</head>
	<body>
		<h2> Listado de la tabla datos </h2>
		<table>
			<tr>
				<td>Identificador</td>
				<td>Sistema Opertivo</td>
				<td>Plan</td>
				<td>Cliente</td>
				<td>vCPUs</td>
				<td>vRAM</td>
				<td>Almacenamiento Nvme</td>
				<td>Aviso</td>
				<td>Email Contacto</td>
				<td>Fecha Solicitud</td>
				<td>Fecha Preparada</td>
			</tr>
			<?php
			include("ejecutaSelectid.php");
			//$res está el resultado de ejecutaSelect.php
			foreach($res as $registros){ ?>
			<tr>
				<td><?php echo $registros["id"]?></td>
				<td><?php echo $registros['so']?></td>
				<td><?php echo $registros['plan']?></td>
				<td><?php echo $registros['cliente']?></td>
				<td><?php echo $registros['vcpu']?></td>
				<td><?php echo $registros['vram']?></td>
				<td><?php echo $registros['disco']?></td>
				<td><?php echo $registros['notificar']?></td>
				<td><?php echo $registros['email']?></td>
				<td><?php echo $registros['fechasolicitud']?></td>
				<td><?php echo $registros['fechapreparada']?></td>
			</tr>
			<?php }?>
		</table>
	</body>
</html>