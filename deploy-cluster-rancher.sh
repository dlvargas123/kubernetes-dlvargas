#!/bin/bash

# Función para verificar la respuesta SSH de un nodo
check_ssh() {
    local node="$1"
    ssh -o ConnectTimeout=5 "$node" exit
    return $?
}

# Array de nodos
nodes=("nodo-21" "nodo-22" "nodo-23")

# Verificar la respuesta SSH para cada nodo
for node in "${nodes[@]}"; do
    if check_ssh "$node"; then
        echo "El nodo $node responde a SSH"
    else
        echo "El nodo $node no responde a SSH"
        exit 1
    fi
done

# Ejecutar la segunda parte del script
echo "Creando Cluster de Kubernetes..."
sleep 2
# Capturar el valor de Registration MASTER
read -p "Introduce el valor de Registration cluster-k8s: " registration_master
#echo "El valor de Registration MASTER es: $registration_master"
sleep 2
# Utilizar las variables capturadas
echo "Registrando nodos y master al cluster de kubernetes"
sleep 2
ssh root@nodo-21 "$registration_master"
sleep 10
ssh root@nodo-22 "$registration_master"
sleep 10
ssh root@nodo-23 "$registration_master"
sleep 10
# Ejecutar el script exportar-kubeconfig.sh
echo "Ejecutando exportar-kubeconfig.sh..."
sleep 2
curl -sSf https://raw.githubusercontent.com/dlvargas123/kubernetes-dlvargas/main/exportar-kubeconfig.sh | bash
# Verificar si se ejecutó correctamente
if [ $? -eq 0 ]; then
  echo "El script exportar-kubeconfig.sh se ejecutó correctamente."
else
  echo "Hubo un error al ejecutar el script."
fi
