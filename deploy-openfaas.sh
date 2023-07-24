chmod 600 /root/.kube/config

# Agregar el repositorio de Helm de OpenFaaS
helm repo add openfaas https://openfaas.github.io/faas-netes/

# Actualizar los repositorios de Helm
helm repo update

# Crear un namespace para OpenFaaS (opcional)
kubectl create namespace openfaas

# Crear el namespace openfaas-fn
kubectl create namespace openfaas-fn

# Desplegar OpenFaaS en el clúster
helm upgrade openfaas --install openfaas/openfaas --namespace openfaas \
  --set functionNamespace=openfaas-fn \
  --set gateway.directFunctions=false

echo -n PASSWORD | faas-cli login --username admin --password-stdin
