# antizapret-autodeploy
Чтобы установить и запустить проект необходимо
подключиться к серверу по ssh
скопировать команду ниже в консоль сервера и нажать Enter. Дождаться окончания установки

После запуска скрипта установятся все необходимые зависимости, SNAP и запустится LXC контейнер Antizapret  
Что будет делать скрипт можно посмотреть тут - 
https://github.com/drno88/antizapret-autodeploy/blob/main/autoinstall-antizapret.sh

<pre>
<code>
curl -o /root/autoinstall-antizapret.sh https://raw.githubusercontent.com/drno88/antizapret-autodeploy/main/autoinstall-antizapret.sh && bash autoinstall-antizapret.sh
</code>
</pre>

