#################################################################################
#!/bin/bash

# Función para verificar la respuesta SSH de un nodo worker o master
check_ssh() {
    local node="$1"
    ssh -o ConnectTimeout=5 "$node" exit
    return $?
}

# Array de nodos workers
nodes=("nodo-21" "nodo-22" "nodo-23")

# Verificar la respuesta SSH para cada nodo worker
for node in "${nodes[@]}"; do
    if check_ssh "$node"; then
        echo "El nodo $node responde a SSH"
    else
        echo "El nodo $node no responde a SSH"
        exit 1
    fi
done

# Array de nodos masters
masters=("master-11" "master-12" "master-13")

# Verificar la respuesta SSH para cada nodo master
for master in "${masters[@]}"; do
    if check_ssh "$master"; then
        echo "El nodo $master responde a SSH"
    else
        echo "El nodo $master no responde a SSH"
        exit 1
    fi
done
#################################################################################
# Ejecutar la segunda parte del script
echo "Creando Cluster de Kubernetes..."
sleep 2
# Capturar el valor de Registro master
read -p "Introduce el valor de Registro master: " registration_master
sleep 2
# Capturar el valor de Registro nodos worker
read -p "Introduce el valor de nodos worker: " registration_worker
sleep 2
# Utilizar las variables capturadas
echo "Registrando master al cluster de kubernetes"
sleep 2
ssh root@master-11 "$registration_master"
sleep 10
ssh root@master-12 "$registration_master"
sleep 10
ssh root@master-13 "$registration_master"
sleep 10
# Utilizar las variables capturadas
echo "Registrando workers al cluster de kubernetes"
sleep 2
ssh root@nodo-21 "$registration_worker"
sleep 10
ssh root@nodo-22 "$registration_worker"
sleep 10
ssh root@nodo-23 "$registration_worker"
sleep 10
# Ejecutar el script exportar-kubeconfig.sh
echo "Ejecutando exportar-kubeconfig.sh..."
sleep 2
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
cp /etc/rancher/rke2/rke2.yaml /root/.kube/config
echo "kubeconfig preparado"
sleep 2
# Verificar si se ejecutó correctamente
if [ $? -eq 0 ]; then
  echo "El script exportar-kubeconfig.sh se ejecutó correctamente."
else
  echo "Hubo un error al ejecutar el script."
fi
#################################################################################
sleep 480
helm repo add jetstack https://charts.jetstack.io
sleep 2
helm repo update
sleep 1
echo "Installing cert-manager..."
sleep 5
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true
sleep 5
echo "cert-manager installation complete."
sleep 10
chmod +x deploy-cert-manager.sh
sleep 5
./deploy-cert-manager.sh
sleep 20
echo "Aplicando issuer.yaml"
kubectl apply -f /root/issuer.yaml
sleep 5
#################################################################################
