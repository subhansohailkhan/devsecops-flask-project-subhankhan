FROM python:3.9-slim-bookworm

RUN apt-get clean \
    && apt-get -y update \
    && apt-get -y install --no-install-recommends \
        nginx \
        python3-dev \
        build-essential \
        uwsgi \
        uwsgi-plugin-python3 \
        libpcre3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY --chown=www-data:www-data . /srv/flask_app

WORKDIR /srv/flask_app

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 80

RUN mkdir -p /var/lib/nginx /var/log/nginx /var/run/nginx \
    && chown -R www-data:www-data /var/lib/nginx /var/log/nginx /var/run/nginx
    
USER www-data

CMD ["sh", "-c", "nginx && uwsgi --ini uwsgi.ini"]
