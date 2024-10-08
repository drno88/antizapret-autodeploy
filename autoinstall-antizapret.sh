#!/bin/bash

echo -e "\e[1;32mПроверка фонового процесса установки dpkg\e[0m"
# Проверка, что установка пакетов не выполняется
while sudo lsof /var/lib/dpkg/lock-frontend; do
    echo "\e[1;31mНайден фоновый процесс установки, Пожалуйста, ждите...\e[0m"
    sleep 5
done
echo -e "\e[1;32mФонового процесса dpkg не найдено. Начинаю...\e[0m"

# Получаем внешний IP-адрес
external_ip=$(curl -s https://ipinfo.io/ip)
echo -e "\e[1;32mДобавляю файл подкачки...\e[0m"
#Добавляем SWAP
swapoff -a;
rm /swapfile;
fallocate -l 2G /swapfile;
chmod 600 /swapfile;
mkswap /swapfile;
swapon /swapfile;
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo -e "\e[1;32mУстановка, подождите...\e[0m"
#Устанавливаем зависимости и софт
apt-get update -qq && apt-get reinstall fail2ban mc htop vnstat wget git curl rsync apt-transport-https ca-certificates software-properties-common net-tools -qq -y;
#Устанавливаем snapd и LXD и настраиваем
apt-get install snapd -qq -y;
snap install lxd --channel=4.0/stable
wget -O lxd-init.yaml https://raw.githubusercontent.com/drno88/antizapret-autodeploy/main/lxd.init;
cat /root/lxd-init.yaml | /snap/bin/lxd init --preseed;

#Установка Antizapret контейнера
#загружаем архив
echo -e "\e[1;32mЗагружаем архив с образом...\e[0m"
wget -O /root/az-img.tar.gz https://s3.timeweb.cloud/42ff5a62-35bbf508-cbf8-483d-b6bc-275ae4e292bc/az-img.tar.gz --no-check-certificate --tries=0 --continue;
wget -O /root/az-img.tar.gz https://s3.timeweb.cloud/42ff5a62-35bbf508-cbf8-483d-b6bc-275ae4e292bc/az-img.tar.gz --no-check-certificate --tries=0 --continue;
#Распаковываем контейнер
echo -e "\e[1;32mРаспаковываем образ...\e[0m"
lxc delete antizapret-vpn -f;
lxc image import /root/az-img.tar.gz --alias antizapret-vpn-img;
lxc init antizapret-vpn-img antizapret-vpn;
sleep 3
#Пробрасываем порты
#lxc config device add antizapret-vpn proxy_443 proxy listen=tcp:[::]:443 connect=tcp:127.0.0.1:1194;
lxc config device add antizapret-vpn proxy_44333 proxy listen=tcp:[::]:44333 connect=tcp:127.0.0.1:1194;
lxc config device add antizapret-vpn proxy_udp_44333 proxy listen=udp:[::]:44333 connect=udp:127.0.0.1:1194;
sleep 3
lxc start antizapret-vpn
sleep 10

echo -e "\e[1;32mГенерируем секретные ключи для OpenVPN...\e[0m"
sleep 2
lxc exec antizapret-vpn -- /bin/bash -c "echo "yes" | /root/easy-rsa-ipsec/generate.sh"
sleep 2
lxc stop antizapret-vpn;
sleep 1
lxc start antizapret-vpn;
sleep 10
#lxc exec antizapret-vpn -- /bin/bash -c "LANG=C.UTF-8 /root/antizapret/doall.sh";
sleep 5
lxc list
sleep 1
echo -e "\e[1;32mКопирую файлы клиента для подключения\e[0m"
lxc file pull --verbose antizapret-vpn/root/easy-rsa-ipsec/CLIENT_KEY/antizapret-client-tcp.ovpn /root/antizapret-client-tcp.ovpn;
echo -e "\e[1;32mantizapret-client-tcp.ovpn - DONE\e[0m"
lxc file pull --verbose antizapret-vpn/root/easy-rsa-ipsec/CLIENT_KEY/antizapret-client-udp.ovpn /root/antizapret-client-udp.ovpn;
echo -e "\e[1;32mantizapret-client-udp.ovpn - DONE\e[0m"

#Очистка
lxc image delete antizapret-vpn-img;
rm autoinstall-antizapret.sh;
rm lxd-init.yaml;
rm az-img.tar.gz;

echo -e "\e[1;32mУстановка завершена\e[0m"
echo -e "\e[1;32mСкачайте файлы antizapret-client-tcp.ovpn и antizapret-client-udp.ovpn из папки root на сервере\e[0m"
echo -e "\e[1;32mВаш IP $external_ip\e[0m"
