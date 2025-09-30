FROM python:3.9-slim-bullseye

RUN apt-get clean \
    && apt-get -y update \
    && apt-get -y install nginx \
       python3-dev \
       build-essential \
       uwsgi \
       uwsgi-plugin-python3 \
       python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx
COPY --chown=www-data:www-data . /srv/flask_app
WORKDIR /srv/flask_app

# Install packages using python3 (system Python that uwsgi uses)
RUN python3 -m pip install -r requirements.txt --src /usr/local/src

CMD ["sh", "-c", "service nginx start && uwsgi --ini uwsgi.ini"]
