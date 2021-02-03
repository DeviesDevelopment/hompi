FROM python:3.6

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY src/requirements.txt ./
RUN pip install -r requirements.txt
COPY src .

# Only used for local testing (ignored by Heroku):
EXPOSE $PORT

CMD ["sh", "-c", "python manage.py runserver 0.0.0.0:$PORT"]
