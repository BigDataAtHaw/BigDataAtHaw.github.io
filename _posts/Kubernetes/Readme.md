Quelle: https://medium.com/@SystemMining/setup-kubenetes-cluster-on-ubuntu-16-04-with-kubeadm-336f4061d929
# Kubernetes
> TODO Einleitung

## Installation

### To deactivate password prompt for sudo-statements
* sudo visudo

> bigdata ALL=(ALL) NOPASSWD: ALL


### System update
* sudo apt-get update && sudo apt-get upgrade -y

### XFCE-Desktop installieren
* sudo apt-get install xubuntu-desktop -y

### apt-transport-https install
* sudo apt-get install -y apt-transport-https ca-certificates

### Add key for Kubernetes Reporsitory
* curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

### sudo -i

* cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
* deb http://apt.kubernetes.io/ kubernetes-xenial main
* EOF

* exit

### Repository List refresh
* sudo apt-get update

# Docker
> TODO Einleitung

## Installation

### Docker holen
* sudo apt-get install -y docker.io

### Kubernetes install
* sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni

### On Master

### Initialize the Kubernetes Cluster
* sudo kubeadm init --pod-network-cidr=10.244.0.0/16

### Run to make "kubectl get node" work
* sudo cp /etc/kubernetes/admin.conf $HOME/
* sudo chown $(id -u):$(id -g) $HOME/admin.conf
* export KUBECONFIG=$HOME/admin.conf
* echo "export KUBECONFIG=$HOME/admin.conf" >> .bashrc

* sudo -i

* sudo cp /etc/kubernetes/admin.conf $HOME/
* sudo chown $(id -u):$(id -g) $HOME/admin.conf
* export KUBECONFIG=$HOME/admin.conf
* echo "export KUBECONFIG=$HOME/admin.conf" >> .bashrc

### Setup Kubernetes Network
* kubectl apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/1.6/rbac.yaml
* kubectl apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/1.6/canal.yaml

* exit

### Get Node-Satus
* kubectl get node

### On Node

### Join the cluster
* kubeadm join --token=<MASTER-TOKEN> <MASTER-IP>

### On Master

### Enable master node run pod
* kubectl taint nodes --all-dedicated

### Install Kubernetes Dashboard
* kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

### Start Dashboard
* kubectl proxy

### Link to Web Server access Dashboard
* http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

### Create Image-Folder
* mkdir ~/image_examples

### Create Spark-Image-Files
* mkdir ~/image_examples/spark

* nano ~/image_examples/spark/spark-master.json
---------------------------------------------------

    {
      "kind": "Pod",
      "apiVersion": "v1",
      "metadata": {
        "name": "spark-master",
        "labels": {
          "name": "spark-master"
        }
      },
      "spec": {
        "containers": [
          {
            "name": "spark-master",
            "image": "gcr.io/google_containers/spark-master",
            "ports": [
              {
                "containerPort": 7077
              }
            ],
            "resources": {
              "limits": {
                "cpu": "100m"
              }
            }
          }
        ]
      }
    }
---------------------------------------------------

* nano ~/image_examples/spark/spark-worker.json
---------------------------------------------------
    {
      "kind": "ReplicationController",
      "apiVersion": "v1",
      "metadata": {
        "name": "spark-worker-controller",
        "labels": {
          "name": "spark-worker"
        }
      },
      "spec": {
        "replicas": 3,
        "selector": {
          "name": "spark-worker"
        },
        "template": {
          "metadata": {
            "labels": {
              "name": "spark-worker",
              "uses": "spark-master"
            }
          },
          "spec": {
            "containers": [
              {
                "name": "spark-worker",
                "image": "gcr.io/google_containers/spark-worker",
                "ports": [
                  {
                    "hostPort": 8888,
                    "containerPort": 8888
                  }
                ],
                "resources": {
                  "limits": {
                    "cpu": "100m"
                  }
                }
              }
            ]
          }
        }
      }
    }
---------------------------------------------------
### Create Images
* kubectl create -f ~/image_examples/spark/spark-master.json
* kubectl create -f ~/image_examples/spark/spark-worker.json





