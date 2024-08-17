# antizapret-autodeploy
Этот проект предназначет для быстрого автоматизированного развертывания контейнера Антизапрет.
Внесены изменения в файлы knot.resolf(для возможности подключения ПОЛНОГО впн, с опцией в файле клиента redirect-gateway def1 bypass-dhcp  
Чтобы установить и запустить проект необходимо
подключиться к серверу по ssh
скопировать команду ниже в консоль сервера и нажать Enter. Дождаться окончания установки  
Подключиться по SSH можно с помощью putty - https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html

После запуска скрипта установятся все необходимые зависимости, SNAP и запустится LXC контейнер Antizapret  
Что будет делать скрипт можно посмотреть тут - 
https://github.com/drno88/antizapret-autodeploy/blob/main/autoinstall-antizapret.sh

<pre>
<code>
curl -o /root/autoinstall-antizapret.sh https://raw.githubusercontent.com/drno88/antizapret-autodeploy/main/autoinstall-antizapret.sh && bash autoinstall-antizapret.sh
</code>
</pre>

