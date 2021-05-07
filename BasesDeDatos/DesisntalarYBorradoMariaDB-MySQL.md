# Desistalación y borrado de B.D COMPLETO de MariaDB ó MySQL 

## MariaDB

```bash
systemctl stop mariadb
apt-get remove --purge mariadb* # MARIADB
apt-get autoremove
apt-get autoclean
rm -rf /etc/mysql
rm -rf /var/lib/mysql*
```

## MySQL

```bash
/etc/init.d/mysql stop
apt-get remove --purge mysql* # MYSQL
apt-get autoremove
apt-get autoclean
rm -rf /etc/mysql
rm -rf /var/lib/mysql*
```