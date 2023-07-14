#!/bin/bash

ruta_script="/etc/rancher/rke2/rke2.yaml"
archivo_temporal="/etc/rancher/rke2/rke2.yaml_bck2"

# Esperar hasta que el archivo exista
while [ ! -f "$ruta_script" ]; do
    echo "El archivo $ruta_script no existe. Esperando..."
    sleep 5  # Pausa de 5 segundos antes de verificar nuevamente
done

echo "El archivo $ruta_script existe."

# Leer el contenido del archivo
contenido_script=$(cat "$ruta_script")

# Eliminar las líneas que contengan "certificate-authority-data"
nuevo_contenido=$(echo "$contenido_script" | grep -v "certificate-authority-data")

# Guardar el nuevo contenido en un archivo temporal
echo "$nuevo_contenido" > "$archivo_temporal"
echo "Se ha eliminado la línea 'certificate-authority-data' del archivo $ruta_script."

# Obtener la IP externa del servidor
ipextp=$(curl -s icanhazip.com)

# Cambiar el valor de server y agregar la línea insecure-skip-tls-verify
contenido_modificado=$(echo "$nuevo_contenido" | sed "s|server: https://127.0.0.1:6443|server: https://$ipextp:6443|\n    insecure-skip-tls-verify: true")

# Guardar el contenido modificado en el archivo temporal
echo "$contenido_modificado" > "$archivo_temporal"
echo "Se ha realizado la modificación en el archivo $ruta_script y se ha guardado en $archivo_temporal."

# Copiar el archivo modificado a la ruta /root/.kube/config
cp "$archivo_temporal" "/root/.kube/config"
echo "Se ha copiado el archivo $archivo_temporal a /root/.kube/config."
