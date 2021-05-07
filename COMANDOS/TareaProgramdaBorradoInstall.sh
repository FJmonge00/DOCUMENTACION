#!/bin/bash
find /home/prestashop-*/install -cmin -20 > $HOME/candidatoBorrar.csv
while IFS=, read directorio
do
    rm -R ${directorio}
done < $HOME/candidatoBorrar.csv