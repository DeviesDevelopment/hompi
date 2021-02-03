#!/bin/bash

pip install -r requirements.txt

python manage.py migrate

echo "Starting server"
python manage.py runserver 0.0.0.0:$PORT
