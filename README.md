# antizapret-autodeploy

Этот проект предназначен для быстрого автоматизированного развертывания контейнера Антизапрет.

## Изменения

- Внесены изменения в файлы `knot.resolf` для возможности подключения полного VPN с опцией в файле клиента `redirect-gateway def1 bypass-dhcp`.
- Внесены домены в файл с доменами для обязательного проксирования (добавлены Instagram, YouTube, Facebook и т.д.).

## Установка и запуск

Чтобы установить и запустить проект, выполните следующие шаги:

1. Подключитесь к серверу по SSH.
2. Скопируйте команду ниже в консоль сервера и нажмите Enter. Дождитесь окончания установки.

Подключиться по SSH можно с помощью [Putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).

```sh
curl -o /root/autoinstall-antizapret.sh https://raw.githubusercontent.com/drno88/antizapret-autodeploy/main/autoinstall-antizapret.sh && bash autoinstall-antizapret.sh
```

После запуска скрипта установятся все необходимые зависимости, SNAP и запустится LXC контейнер Antizapret.

## Скрипт установки

Что будет делать скрипт, можно посмотреть [здесь](https://github.com/drno88/antizapret-autodeploy/blob/main/autoinstall-antizapret.sh).

## Обновление списка заблокированных доменов

После окончания установки запустите в консоли следующую команду и дождитесь обновления списка заблокированных доменов:

```sh
lxc exec antizapret-vpn -- /bin/bash -c "LANG=C.UTF-8 /root/antizapret/doall.sh"
```

---
