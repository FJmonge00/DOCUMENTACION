# OA Servicios

Se compone de los siguientes programas:

- ***`oa.sh`***: Busca en la base de datos la existencia de nuevos Servicios para lanzar al cluster, crea las entradas en `$LANZADERA/cola/servicios.csv` con los parámetros indicados en la Base de datos. Dependiendo del servicio, llamará a un script u otro ej: `OAJoomla.sh` (Para Joomla) o `OAWordpress.sh` (Para Wordpress). para que estas preparen los ficheros YAML con los correspondientes parámetros.
Una vez que se han generado los ficheros YAML en la lanzadera en $LANZADERA se ejecuta el lanzar.sh del servicios especifico que se este lanzando. Siempre todo esto queda registrado en los logs y es notificado al cliente una vez lanzado mediante via email bajo el dominio topserver@gmail.com.

## Script `oa.sh`

```bash
#!/bin/bash
# Consulta en MariaDB
echo "SELECT id,app,cliente,notificar,email FROM servicios WHERE fecha > NOW() - INTERVAL 3 MINUTE" | mariadb -N -B hosting > $LANZADERA/cola/servicios.csv
# Prepara CSV
sed -i 's/\t/,/g' $LANZADERA/cola/servicios.csv # Control errores Eliminar Espacios
if [ ! -s $LANZADERA/cola/servicios.csv ] # Si no tiene datos (Vacio)
    then
        echo "Ningun servicio en cola: $(date +"%d-%m-%Y-%R:%S")" > $LANZADERA/cola/servicios.csv
        echo "Proximo lanzamiento: $(date --date="+3 min" +"%d-%m-%Y-%R:%S")" >> $LANZADERA/cola/servicios.csv
    else
        echo "$(date +"%d-%m-%Y-%R:%S")" >> $OAK8SLOG/oa/serviciosLanzados.log
        echo "" >> $OAK8SLOG/oa/serviciosLanzados.log
        cat $LANZADERA/cola/servicios.csv >> $OAK8SLOG/oa/serviciosLanzados.log
        echo "" >> $OAK8SLOG/oa/serviciosLanzados.log
        while IFS=, read id app cliente notificar email
        do
            mkdir $LANZADERA/${app}-${id} # Carpeta base de lanzadera del servicio
            case ${app} in
                'joomla') sh OAJoomla.sh $id $cliente $notificar $email
                ;;
                'wordpress') sh OAWordpress.sh $id $cliente $notificar $email
                ;;
                'prestashop') sh OAPrestashop.sh $id $cliente $notificar $email
                ;;
                'mediawiki') echo "mediawiki"
                ;;
                'drupal') sh OADrupal.sh $id $cliente $notificar $email
                ;;
                *) echo "Error de lanzamiento: $(date +"%d-%m-%Y-%R:%S")" >> $OAK8SLOG/oa/serviciosLanzados.log
                   echo "Valor de Id: ${id}" >> $OAK8SLOG/oa/serviciosLanzados.log
                   echo "Valor de App: ${app}" >> $OAK8SLOG/oa/serviciosLanzados.log
                   echo "Valor de Cliente: ${cliente}" >> $OAK8SLOG/oa/serviciosLanzados.log
                ;;
            esac
        done < $LANZADERA/cola/servicios.csv
fi
```

## [OAJoomla.sh](oaJoomla.md)
## [OAWordpress.sh](oaWordpress.md)
## [OAPrestashop.sh](oaPrestashop.md)
## [OADrupal.sh](oaDrupal.md)
