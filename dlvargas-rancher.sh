#!/bin/bash

# Descargar el script
wget https://raw.githubusercontent.com/dlvargas123/kubernetes-dlvargas/main/deploy-cluster-rancher.sh

# Dar permisos de ejecución al script descargado
chmod +x deploy-cluster-rancher.sh

# Ejecutar el script
./deploy-cluster-rancher.sh
