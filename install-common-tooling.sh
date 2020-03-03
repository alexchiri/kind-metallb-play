#!/bin/bash

sudo apt-get update && sudo apt-get install -y jq curl unzip git python3 apt-transport-https ca-certificates software-properties-common jid

export KUBECTL_VERSION="v1.16.3"
export HELM_VERSION="v3.1.1"
export HELMSMAN_VERSION="3.1.0"
export GO_VERSION="1.13"
export GO111MODULE="on"
export KIND_VERSION="v0.7.0"

wget "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" \
  && sudo tar -xvzf "./go${GO_VERSION}.linux-amd64.tar.gz" -C /usr/local \
  && echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc && source ~/.bashrc

curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && sudo mv ./kubectl /usr/local/bin/kubectl

curl -LO https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -xzvf ./helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && chmod +x ./linux-amd64/helm \
    && sudo mv ./linux-amd64/helm /usr/local/bin/helm

# install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo usermod -aG docker "${USER}"

# install kind
go get "sigs.k8s.io/kind@${KIND_VERSION}"

# install fortio
go get fortio.org/fortio

echo "export PATH=\$PATH:/home/parallels/go/bin"  >> ~/.bashrc && source ~/.bashrc

# install helmdiff
helm plugin install https://github.com/databus23/helm-diff --version master

# install helmsman
curl -LO "https://github.com/Praqma/helmsman/releases/download/v${HELMSMAN_VERSION}/helmsman_${HELMSMAN_VERSION}_linux_amd64.tar.gz" \
  && tar -xzvf "./helmsman_${HELMSMAN_VERSION}_linux_amd64.tar.gz" \
  && chmod +x ./helmsman \
  && sudo mv ./helmsman /usr/local/bin/helmsman

su - "${USER}"







