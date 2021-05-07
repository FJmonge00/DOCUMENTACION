# Instalacion y Configuracion de phpMyAdmin 5.X.

Principalmente haré uso de la shell para el manejo de la base de datos, pero no está mal tener algún interfaz grafico para la ver y editar algunos de datos de manera eventual para algunos casos
## Instalación.

### Preparación de PHP y Apache.

```bash
apt update
apt -y install php-bz2 php-mbstring php-xml php-zip
apt -y install php7.3-bz2 php7.3-mbstring php7.3-xml php7.3-zip # Ver version de PHP
systemctl reload apache2
```

### Descarga de phpMyAdmin e ""instalacion"".

```bash
cd /var/www/html
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.zip
unzip phpMyAdmin-5.1.0-all-languages.zip
mv phpMyAdmin-5.1.0-all-languages phpMyAdmin
chown www-data -R /var/www/html/phpmyadmin/
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

Es necesario crear algunas tablas para del sistema para el funcinamiento de phpMyAdmin

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
cat /var/www/html/phpmyadmin/sql/create_tables.sql | mysql -u pma -p
```