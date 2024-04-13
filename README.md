Курсовая работа на профессии "DevOps-инженер с нуля" - Логинов Даниил
===============
---
Terraform модуль
===
Файлы находятся в корне проекта. Основной файл *[Terraform-main.tf](https://github.com/Loginochka/Coursework-DevOps/blob/main/Terraform-main.tf)*

Используются стандартные ресурсы YC. Из особенносткей только nat_шлюз для возможности ВМ выходить в сеть для загрузки пакетов и экономии белых IP адрессов.

---
Elasticsearch модуль
==
Файлы находятся в папке elk *[Elasticsearch](https://github.com/Loginochka/Coursework-DevOps/tree/main/elk)*

Достпу к кибане по ссылке: *[Kibana](http://62.84.114.252:5601/app/observability/overview?rangeFrom=now-1d&rangeTo=now)*

---
Zabbix модуль
===
Было решено вместо Prometheus использовать zabbix

Файлы находятся в папке elk *[Elasticsearch](https://github.com/Loginochka/Coursework-DevOps/tree/main/zabbix)*

Компоненты сервиса подняты отдельно, для разграничения доступов до ВМ и оптимизации ресурсов. И так более красиово )

Настройка мониторинга осуществляется через API запросы *[api](https://github.com/Loginochka/Coursework-DevOps/tree/main/api)*

Доступ к Zabbix логин\пароль 
+ Admin\zabbix

*[Dashboard с графиками](http://158.160.113.248/zabbix.php?action=dashboard.view)*

---

#### Файлы конфигурация лежат в папке *[packages](https://github.com/Loginochka/Coursework-DevOps/tree/main/packages)*

---

Также есть файл со схематичным изображением инфраструктуры 

Для просмотра рекомендую использовать *[app.diagrams.net](https://app.diagrams.net/)*

*[файл](https://github.com/Loginochka/Coursework-DevOps/blob/main/%D0%9A%D1%83%D1%80%D1%81%D0%BE%D0%B2%D0%B0%D1%8F.drawio)*

---

*[Сайт живет тут](http://158.160.145.200)*
===