FROM python:3.6

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY src .
COPY start_server.sh .
RUN chmod +x start_server.sh

# Only used for local testing (ignored by Heroku):
EXPOSE $PORT

ENTRYPOINT ["./start_server.sh"]
