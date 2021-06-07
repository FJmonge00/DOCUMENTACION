# Instalacion y Configuracion de phpMyAdmin 5.X.

Principalmente haré uso de la shell para el manejo de la base de datos, pero no está mal tener algún interfaz gráfico via web para la ver y editar algunos de datos en algunos casos.

## Instalación.

### Preparación de PHP y Apache.

```bash
apt update
apt -y install php-bz2 php-mbstring php-xml php-zip
apt -y install php7.3-bz2 php7.3-mbstring php7.3-xml php7.3-zip # Ver version de PHP
systemctl reload apache2
```

> Si no sabemos la versión de apache disponible para nuestra distribucion podemos remplazar los nombres todos los paquetes con solo php sin indicar la vesión Ej: `apt install php-xml` en vez de `apt install php7.3-xml` 

### Descarga de phpMyAdmin e ""instalacion"".

```bash
cd /var/www/html # Acceder al lugar donde vamos a poner phpMyAdmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.zip # Descarga de  phpMyAdmin
unzip phpMyAdmin-5.1.0-all-languages.zip # Descomprimimos el .zip
mv phpMyAdmin-5.1.0-all-languages phpMyAdmin # Sacamos de la carpeta que se ha generado
chown www-data -R /var/www/html/phpmyadmin/ # Aplicamos los permisos pertinentes para Apache
```

**ó** 

```bash
cd /var/www/html
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.tar.xz
tar xf phpMyAdmin-5.1.0-all-languages.tar.xz -C /var/www/html/
mv phpMyAdmin-5.1.0-all-languages phpMyAdmin
chown www-data -R /var/www/html/phpmyadmin/
```

### Preparar la base de datos de phpMyAdmin

Es necesario crear algunas tablas del sistema para el funcinamiento de phpMyAdmin

```bash
mysql -u root -p
```

```sql
create user pma@localhost identified by 'Coria21';
create user pma@localhost identified identified with mysql_native_password by 'Coria21';
grant all privileges on phpmyadmin.* to pma@localhost;
exit
```

### Creación de las tablas de phpmyadmin.
 
```bash
cat /var/www/html/phpmyadmin/sql/create_tables.sql | mysql -u pma -p # SQL por defecto que trae phpMyAdmin
```

________________________________________
*[Volver al atrás...](../README.md)*