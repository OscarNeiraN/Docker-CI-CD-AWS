#!/bin/bash

sudo dnf update -y

sudo dnf install -y docker

sudo systemctl enable --now docker
sudo usermod -aG docker ec2-user

cat << 'EOF' | sudo tee /usr/local/bin/post-reboot.sh
#!/bin/bash
sleep 10
docker run hello-world


sudo systemctl disable post-reboot.service
EOF
sudo chmod +x /usr/local/bin/post-reboot.sh

cat << EOF | sudo tee /etc/systemd/system/post-reboot.service
[Unit]
Description=Script post-reboot para continuar despliegue
After=network.target docker.service

[Service]
ExecStart=/usr/local/bin/post-reboot.sh
Type=oneshot
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable post-reboot.service

sudo reboot
