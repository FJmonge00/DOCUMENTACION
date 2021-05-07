<?php
function borrarDirectorio($directorio) {
    if(!$dh = @opendir($directorio)) return;
    while (false !== ($current = readdir($dh))) {
        if($current != '.' && $current != '..') {
            echo 'Se ha borrado el archivo '.$directorio.'/'.$current.'<br/>';
            if (!@unlink($directorio.'/'.$current)) 
                borrarDirectorio($directorio.'/'.$current);
        }       
    }
    closedir($dh);
    echo 'Se ha borrado el directorio '.$directorio.'<br/>';
    @rmdir($directorio);
}
borrarDirectorio('install');
?>