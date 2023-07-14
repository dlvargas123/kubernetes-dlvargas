#!/bin/bash

# Función para verificar la conexión SSH a un nodo
function check_ssh_connection() {
    local node=$1
    ssh -o BatchMode=yes -o ConnectTimeout=5 $node "echo 2>&1" && return 0 || return 1
}

# Nodos a verificar
nodes=("nodo-21" "nodo-22" "nodo-23")

# Variable para controlar si todos los nodos están disponibles
all_nodes_available=true

# Verificar conexión SSH para cada nodo
for node in "${nodes[@]}"; do
    if check_ssh_connection $node; then
        echo "Conexión SSH exitosa con $node"
    else
        echo "No se pudo establecer conexión SSH con $node"
        all_nodes_available=false
    fi
done

# Ejecutar segunda parte del script si todos los nodos están disponibles
if $all_nodes_available; then
    echo "Todos los nodos están disponibles. Configurando cluster de Kubernetes…"

    # Capturar el valor de Registration cluster-k8s
    read -p "Introduce el valor de Registration cluster-k8s: " registration_master
    sleep 2

    echo "Registrando nodos y master al cluster de Kubernetes"
    sleep 2

    # Lista de nodos
    nodos=("nodo-21" "nodo-22" "nodo-23")

    # Registrar nodos y ejecutar el script exportar-kubeconfig
    for nodo in "${nodos[@]}"; do
        ssh root@"$nodo" "$registration_master"
        sleep 10

        # Descargar el script exportar-kubeconfig
        wget -O exportar-kubeconfig.sh https://raw.githubusercontent.com/dlvargas123/kubernetes-dlvargas/main/exportar-kubeconfig.sh

        # Asignar permisos de ejecución al script
        chmod +x exportar-kubeconfig.sh

        # Ejecutar el script exportar-kubeconfig.sh
        ./exportar-kubeconfig.sh
    done
else
    echo "Algunos nodos no están disponibles. No se ejecutará la segunda parte del script."
fi
