# Сайт доставки еды Star Burger

Это сайт сети ресторанов Star Burger. Здесь можно заказать превосходные бургеры с доставкой на дом.

![скриншот сайта](https://dvmn.org/filer/canonical/1594651635/686/)


Сеть Star Burger объединяет несколько ресторанов, действующих под единой франшизой. У всех ресторанов одинаковое меню и одинаковые цены. Просто выберите блюдо из меню на сайте и укажите место доставки. Мы сами найдём ближайший к вам ресторан, всё приготовим и привезём.

На сайте есть три независимых интерфейса. Первый — это публичная часть, где можно выбрать блюда из меню, и быстро оформить заказ без регистрации и SMS.

Второй интерфейс предназначен для менеджера. Здесь происходит обработка заказов. Менеджер видит поступившие новые заказы и первым делом созванивается с клиентом, чтобы подтвердить заказ. После оператор выбирает ближайший ресторан и передаёт туда заказ на исполнение. Там всё приготовят и сами доставят еду клиенту.

Третий интерфейс — это админка. Преимущественно им пользуются программисты при разработке сайта. Также сюда заходит менеджер, чтобы обновить меню ресторанов Star Burger.

## Локальный запуск (Docker Compose)

Проект запускается в нескольких контейнерах:

- `db` — контейнер с PostgreSQL.
- `backend` — контейнер с Django-приложением, которое запускается через Gunicorn.
- `frontend` — контейнер, который собирает фронтенд-бандлы с помощью Parcel.
- `nginx` — контейнер с Nginx, который принимает HTTP-запросы, раздаёт `static` и `media`, и проксирует остальные запросы в `backend`.

Данные не теряются при пересоздании контейнеров, потому что используются Docker volumes:

- star-burger-docker_postgres_data — данные PostgreSQL.
- star-burger-docker_media_data — загруженные медиафайлы.
- star-burger-docker_static_data — собранная статика.
- star-burger-docker_bundles_data — фронтенд-бандлы.

1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/Azad0645/star-burger-docker.git
   ```

2. Создайте файл `.env`:
   ```
   SECRET_KEY=secret-key
   DEBUG=True
   ALLOWED_HOSTS=127.0.0.1,localhost,starburger.store,www.starburger.store
   CSRF_TRUSTED_ORIGINS=https://starburger.store,https://www.starburger.store
   YANDEX_GEOCODER_API_KEY=your_yandex_api_key
   ```

`DATABASE_URL` для запуска через Docker Compose задаётся в `docker-compose.yaml`.

3. Соберите и поднимите контейнеры:
   ```bash
   docker compose up --build
   ```

4. Примените миграции в новом терминале:
   ```bash
   docker compose run --rm backend python manage.py migrate
   ```

5. Соберите статику:
   ```bash
   docker compose run --rm backend python manage.py collectstatic --noinput
   ```

6. Создайте суперпользователя:
   ```bash
   docker compose run --rm backend python manage.py createsuperuser
   ```

Откройте сайт на  http://127.0.0.1:8000

## Деплой на сервер (Docker Compose)

1. Установите Docker на сервере.

2. Запуск на сервере:
   ```bash
   cd /opt/projects
   git clone git@github.com:Azad0645/star-burger-docker.git
   cd star-burger-docker
   docker compose up --build -d
   docker compose run --rm backend python manage.py migrate
   docker compose run --rm backend python manage.py collectstatic --noinput
   ```

После перезагрузки сервера контейнеры автоматически поднимаются через systemd unit.

3. Для быстрого обновления проекта на сервере используется скрипт:
   ```bash
   ./deploy_star_burger.sh
   ```

## Проверка проекта

- сайт: https://starburger.store
- админка: https://starburger.store/admin/
- страница менеджера: https://starburger.store/manager/

## Цели проекта

Код написан в учебных целях — это урок в курсе по Python и веб-разработке на сайте [Devman](https://dvmn.org). За основу взят проект [FoodCart](https://github.com/Saibharath79/FoodCart).
