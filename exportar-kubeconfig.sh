#!/bin/bash

ruta_script="/etc/rancher/rke2/rke2.yaml"

while [ ! -f "$ruta_script" ]; do
    echo "El archivo $ruta_script no existe. Esperando..."
    sleep 5  # Pausa de 5 segundos antes de verificar nuevamente
done
# El archivo existe, puedes ejecutar el script aquí
ruta_script1="/etc/rancher/rke2/rke2.yaml"
sleep 1
# Leer el contenido del archivo script1
contenido_script1=$(cat "$ruta_script1")
sleep 1
# Eliminar las líneas que contengan "certificate-authority-data"
nuevo_contenido=$(echo "$contenido_script1" | grep -v "certificate-authority-data")
sleep 1
# Guardar el nuevo contenido en un archivo temporal
archivo_temporal="/etc/rancher/rke2/rke2.yaml_bck2"
echo "$nuevo_contenido" > "$archivo_temporal"
sleep 1
echo "Se ha eliminado la línea 'certificate-authority-data' del archivo script1."
sleep 1
ipextp=$(curl -s icanhazip.com)
sleep 1
ruta_archivo="/etc/rancher/rke2/rke2.yaml_bck2"
ipextp=$(curl -s icanhazip.com) # Reemplaza "ip_del_servidor" por la IP externa correspondiente
sleep 1
# Leer el contenido del archivo
contenido=$(cat "$ruta_archivo")
sleep 1
ipextp=$(curl -s icanhazip.com) # Reemplaza "ip_del_servidor" por la IP externa correspondiente
# Cambiar el valor de server
contenido_modificado=$(echo "$contenido" | sed "s|server: https://127.0.0.1:6443|server: https://$ipextp:6443|")
sleep 1
# Agregar la línea insecure-skip-tls-verify
contenido_modificado=$(echo "$contenido_modificado" | sed "/server: https:\/\/$ipextp:6443/a \    insecure-skip-tls-verify: true")
sleep 1
# Guardar el contenido modificado en el archivo
echo "$contenido_modificado" > "$ruta_archivo"
sleep 1
echo "Se ha realizado la modificación en el archivo $ruta_archivo."
sleep 1
# Copiar el archivo modificado a la ruta /root/.kube/config
cp "$ruta_archivo" "/root/.kube/config"
echo "Se ha realizado la modificación en el archivo $ruta_archivo y se ha copiado a /root/.kube/config."
