FROM python:3.9.23-slim-bullseye

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

RUN apt-get clean \
    && apt-get -y update \
    && apt-get -y install nginx \
       python3-dev \
       build-essential \
       gcc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY conf/nginx.conf /etc/nginx
COPY . /srv/flask_app
WORKDIR /srv/flask_app

# Install Python packages
RUN pip3 install --no-cache-dir uwsgi -r requirements.txt

# Change ownership to non-root user
RUN chown -R appuser:appuser /srv/flask_app \
    && chown -R appuser:appuser /var/log/nginx \
    && chown -R appuser:appuser /var/lib/nginx \
    && touch /run/nginx.pid \
    && chown appuser:appuser /run/nginx.pid

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/ || exit 1

# Switch to non-root user
USER appuser

EXPOSE 5000

CMD ["sh", "-c", "nginx && /usr/local/bin/uwsgi --ini uwsgi.ini"]
