#!/bin/bash

set -e

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing required dependencies..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

########################################
# Install Docker
########################################
echo "Installing Docker..."

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker $USER

echo "Docker installed successfully."

########################################
# Install kubectl
########################################
echo "Installing kubectl..."

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "kubectl installed successfully."

########################################
# Install Minikube
########################################
echo "Installing Minikube..."

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

echo "Minikube installed successfully."

########################################
# Install Java (Required for Jenkins)
########################################
echo "Installing Java..."
sudo apt install -y  openjdk-21-jre

########################################
# Install Jenkins
########################################
echo "Installing Jenkins..."

sudo mkdir -p /usr/share/keyrings

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install -y jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "Jenkins installed successfully."

sudo usermod -aG docker jenkins

########################################
# Final Info
########################################

echo "========================================"
echo "Installation Complete!"
echo "Please Run --- newgrp docker --- so docker changes can be applied."
echo ""
echo "Check versions:"
echo "  docker --version"
echo "  kubectl version --client"
echo "  minikube version"
echo "  systemctl status jenkins"
echo ""
echo "Jenkins initial password:"
echo "  sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo "========================================"