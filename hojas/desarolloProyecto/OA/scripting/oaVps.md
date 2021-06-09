# OA VPS

Se compone de los siguientes programas:

- ***`oaVPS.sh`***: Busca en la base de datos la existencia de nuevos VPS para levantar, crea las entradas en `$SALIDAVPS/salidaVPS.txt` y `$SALIDAVPS/salidaVPS.conf`  con los parámetros y plan de el VPS y llama a `gruaVPS.sh` (Para Máquinas Linux) o `gruaVPSWindows.sh` (Para las máquinas Windows) para que estas levanten las máquinas y continuen el proceso. Guarda los Logs de salida o lanzamiento de los VPS en `$OAVPSLOG/$cliente/$cliente-$id/preparacion.log` y crea la entrada Fecha-Hora en la Base de datos cuando la máquina esta disponible.

- ***`gruaVPS.sh`***: Toma la máquina base de `$BASEVPS` y la clona en `$VPS`, una vez que esta clonada le realiza el `virt-sysprep` limpiando y generando toda las configuraciones, usuarios, hash, claves ssh, y entidades unicas que pueda tener esta máquina y generando unas nuevas. Todo esto es realizado sin arrancar la máquina en ningún momento. Posteriormente configura el hardware según los parámetros indicados por `oaVPS.sh` provenientes de la Base de Datos, arranca el VPS, Lanza el PlayBook correspondiente de Ansible según el plan o entorno elegido y envia una notificacion de bienvenida con los datos de acceso al cliente via email bajo el dominio topserver@gmail.com.

*FUENTE OFICIAL: https://libguestfs.org*

> "Sysprep" significa herramienta de "preparación del sistema". El nombre proviene del programa de Microsoft sysprep.exe que se utiliza para desconfigurar las máquinas con Windows en preparación para su clonación. Dicho esto, virt-sysprep no funciona actualmente en invitados de Microsoft Windows. Planeamos admitir la preparación del sistema de Windows en una versión futura, y ya tenemos código para hacerlo.

En el caso de Windows no es posible realizar el sysprep con KVM en otros hipervisores más optimizados con Windows como es VMware ESXI o Hyper-V. Podemos realizarlo de manera nativa. 

Dicho esto:

- ***`gruaVPSWindows.sh`***: Toma la máquina base de `$BASEVPS` y la clona en `$VPS`. Posteriormente configura el hardware según los parámetros indicados por `oaVPS.sh` provenientes de la Base de Datos, arranca el VPS y envia una notificacion de bienvenida con los datos de acceso al cliente via email bajo el dominio topserver@gmail.com.

>Pára poder clonar las máquinas sin que existan conflictos o información repetida entre ellas se realiza el `sysprep.exe` en la máquina base y esta se clona una vez que se ha ejecutado el `sysprep.exe` limpiando y generando toda las configuraciones, usuarios, hash, claves ssh, y entidades unicas que pueda tener Windows y generando unas nuevas en el arranque.