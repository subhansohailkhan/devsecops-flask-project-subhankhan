FROM python:3.9-slim-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    python3-dev \
    build-essential \
    uwsgi \
    uwsgi-plugin-python3 \
 && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx
COPY --chown=www-data:www-data . /srv/flask_app
WORKDIR /srv/flask_app

RUN pip install -r requirements.txt --src /usr/local/src

CMD ["sh", "-c", "service nginx start && uwsgi --ini uwsgi.ini"]

USER root
