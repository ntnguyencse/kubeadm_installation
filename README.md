## Every Node
```
$ chmod +x kubeadm_installation.sh
$ source kubeadm_installation.sh
```

## Only Master Node
```
$ sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address={__REPLACE_WITH_PRIVATE_IP__MASTER}
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
$ kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
$ kubectl get nodes
```
  - Check TOKEN_NUM
  ```
  $ kubeadm token list
  ```
  - Check HASH_NUM
  ```
  $ openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
  ```
  - Bash Completion at Master Node
  ```
  $ chmod +x k8s_bash-completion.sh
  $ source k8s_bash-completion.sh
  ```
  
## Only Worker Node
```
$ sudo kubeadm join {__REPLACE_WITH_PRIVATE_IP__MASTER}:6443 --token {TOKEN_NUM} --discovery-token-ca-cert-hash sha256:{HASH_NUM}
```
# Scrip notes:
## Install master node: 
[Script install Master node](script/master.sh)

## Install worker node

[Script install worker node](script/worker.sh)

## Install metric server

[File configuration metric server](script/components.yaml)

Install metric server command: 
```
kubectl apply -f components.yaml
```

## Destroy and clean up
Run [Reset script](script/reset.sh) on master and all of worker node to destroy and clean up the Kubernetes cluster.
