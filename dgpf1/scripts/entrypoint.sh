#!/bin/sh
set -e

# Default values (can be overridden via env)
: "${DJANGO_WSGI_MODULE:=dgpf1.wsgi:application}"
: "${GUNICORN_BIND:=0.0.0.0:8000}"
: "${GUNICORN_WORKERS:=3}"
: "${GUNICORN_THREADS:=2}"
: "${GUNICORN_TIMEOUT:=120}"

# Optional: wait for database
if [ "$WAIT_FOR_DB" = "true" ]; then
  echo "Waiting for database..."
  while ! nc -z "$DB_HOST" "$DB_PORT"; do
    sleep 1
  done
  echo "Database is up!"
fi

# Optional: run migrations
if [ "$RUN_MIGRATIONS" = "true" ]; then
  echo "Running migrations..."
  python manage.py migrate --noinput
fi

# Optional: collect static files
if [ "$COLLECTSTATIC" = "true" ]; then
  echo "Collecting static files..."
  python manage.py collectstatic --noinput
fi

# If user passes a custom command, run it instead
if [ "$#" -gt 0 ]; then
  exec "$@"
fi

# Default: start Gunicorn
echo "Starting Gunicorn..."
exec gunicorn "$DJANGO_WSGI_MODULE" \
  --bind "$GUNICORN_BIND" \
  --workers "$GUNICORN_WORKERS" \
  --threads "$GUNICORN_THREADS" \
  --timeout "$GUNICORN_TIMEOUT"