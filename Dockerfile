FROM python:3.9-slim-bullseye

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    python3-dev \
    build-essential \
    uwsgi \
    uwsgi-plugin-python3 \
 && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /srv/flask_app

# Copy only requirements first (so Docker caches this layer when code changes)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY --chown=www-data:www-data . .

# Expose Flask port
EXPOSE 5000

# Start services
CMD ["sh", "-c", "service nginx start && uwsgi --ini uwsgi.ini"]

# Run as www-data for security
USER www-data
