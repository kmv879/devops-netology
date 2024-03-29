# Домашнее задание к занятию «Компоненты Kubernetes»

### Цель задания

Рассчитать требования к кластеру под проект

------

### Задание. Необходимо определить требуемые ресурсы
Известно, что проекту нужны база данных, система кеширования, а само приложение состоит из бекенда и фронтенда. Опишите, какие ресурсы нужны, если известно:

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. База данных должна быть отказоустойчивой. Потребляет 4 ГБ ОЗУ в работе, 1 ядро. 3 копии. 
3. Кеш должен быть отказоустойчивый. Потребляет 4 ГБ ОЗУ в работе, 1 ядро. 3 копии. 
4. Фронтенд обрабатывает внешние запросы быстро, отдавая статику. Потребляет не более 50 МБ ОЗУ на каждый экземпляр, 0.2 ядра. 5 копий. 
5. Бекенд потребляет 600 МБ ОЗУ и по 1 ядру на копию. 10 копий.

----

#### Ответ


Расчет ресурсов:

   База данных: 4 ГБ ОЗУ и 1 ядро * 3 копии = 12 ГБ ОЗУ, 3 ядра.  
   Кеш: 4 ГБ ОЗУ и 1 ядро * 3 копии = 12 ГБ ОЗУ, 3 ядра.  
   Фронтенд: 50 МБ ОЗУ и 0.2 ядра * 5 копий = 250 МБ ОЗУ, 1 ядро.  
   Бекенд: 600 МБ ОЗУ и 1 ядро * 10 копий = 6 ГБ ОЗУ, 10 ядер. 
   
Итого: 

   Оперативная память: 12 + 12 + 0.25 + 6 = 30.25 ГБ ОЗУ  
   Процессор: 3 + 3  + 1  + 10 = 17 ядер.

Расчет серверов.

Для воркер нод: 10 ядер и 16 ГБ оперативной памяти; для мастер нод: 2 ядра и 2 ГБ оперативной памяти.  

Минимальное кол-во рабочих воркер нод для работы приложений =   
ОЗУ 30.25/16=1,89 - округляем вверх = 2  
CPU 17/10=1,7 - округляем и получаем = 2  
Добавим одну воркер ноду для высокой доступности  
И получаем 3 worker ноды 10 ядер и 16гб каждая.  

Master ноды - 3 сервера с 2 ядрами и 2 ГБ ОЗУ.  

Итого для серверов: 3 рабочие воркер ноды с 10 ядрами и 16 ГБ ОЗУ, и 3 мастер ноды с 2 ядрами и 2 ГБ ОЗУ. 

