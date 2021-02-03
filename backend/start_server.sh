#!/bin/bash

pip install -r requirements.txt

python manage.py migrate

if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ] ; then
    echo "Creating superuser account"
    python manage.py createsuperuser --no-input
fi

echo "Starting server"
exec python manage.py runserver 0.0.0.0:$PORT
