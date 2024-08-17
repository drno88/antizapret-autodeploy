#!/bin/bash

# Получаем внешний IP-адрес
external_ip=$(curl -s ifconfig.me)
#Добавляем SWAP
swapoff -a;
fallocate -l 2G /swapfile;
chmod 600 /swapfile;
mkswap /swapfile;
swapon /swapfile;
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

#Устанавливаем зависимости и софт
apt-get update -qq && apt-get reinstall fail2ban mc htop vnstat wget git curl rsync apt-transport-https ca-certificates software-properties-common net-tools -qq -y;
#Устанавливаем snapd и LXD и настраиваем
apt-get install snapd -qq -y;
snap install lxd --channel=4.0/stable
wget -O lxd-init.yaml https://raw.githubusercontent.com/drno88/antizapret-autodeploy/main/lxd.init;
cat /root/lxd-init.yaml | /snap/bin/lxd init --preseed;

#Установка Antizapret контейнера
#загружаем архив
wget -O /root/az-img.tar.gz https://s3.timeweb.cloud/42ff5a62-35bbf508-cbf8-483d-b6bc-275ae4e292bc/az-img.tar.gz --no-check-certificate --tries=0;
wget -O /root/az-img.tar.gz https://s3.timeweb.cloud/42ff5a62-35bbf508-cbf8-483d-b6bc-275ae4e292bc/az-img.tar.gz --no-check-certificate --tries=0;
#Распаковываем контейнер
lxc image import /root/az-img.tar.gz --alias antizapret-vpn-img;
lxc init antizapret-vpn-img antizapret-vpn;
sleep 3
#Пробрасываем порты
lxc config device add antizapret-vpn proxy_443 proxy listen=tcp:[::]:443 connect=tcp:127.0.0.1:1194;
lxc config device add antizapret-vpn proxy_44333 proxy listen=tcp:[::]:44333 connect=tcp:127.0.0.1:1194;
sleep 3
lxc start antizapret-vpn
sleep 10
lxc list
echo -e "\e[1;32mУстановка завершена\e[0m"
echo -e "\e[1;32mЗамените IP адрес в файле клиента на Ваш IP $external_ip\e[0m"
