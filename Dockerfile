FROM python:3.9-slim-bullseye

RUN apt-get clean \
    && apt-get -y update \
    && apt-get -y install nginx \
       python3-dev \
       build-essential \
       gcc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx
COPY --chown=www-data:www-data . /srv/flask_app
WORKDIR /srv/flask_app

# Install ALL Python packages including uwsgi via pip
RUN pip3 install uwsgi -r requirements.txt

CMD ["sh", "-c", "service nginx start && /usr/local/bin/uwsgi --ini uwsgi.ini"]
