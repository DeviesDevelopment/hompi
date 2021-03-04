# hompi
Home Planner by Hisingen Heavy Metal Squad

## Backend (Django)
### Requirements
* [Python 3](https://www.python.org/downloads/)
* [pip](https://pip.pypa.io/en/stable/installing/)
* Docker

### Setup

Start the local server using Docker:

    cd backend
    docker build -t hompi .
    docker run -e PORT=8000 -p 8000:8000 hompi

If you need to create an admin user, run the container like this:

    docker run -e PORT=8000 -p 8000:8000 -e DJANGO_SUPERUSER_USERNAME=admin -e DJANGO_SUPERUSER_PASSWORD=admin -e DJANGO_SUPERUSER_EMAIL=admin@admin.se hompi

### Database
When running locally, an SQLite database will be used by default. By adding `-e DATABASE_URL=<postgres://user:password@host:port/something>` to the `docker run` command you can instead use an external database.

The production database is hosted as an add-on on Heroku. When running the production backend, Heroku has already populated the `DATABASE_URL` environment variable when first setting up the database.

#### Browsing production database
* Install Heroku CLI
* Install PostgreSQL tools: https://devcenter.heroku.com/articles/heroku-postgresql#local-setup
* Run `heroku pg:psql --app=hompi-backend`

### Adding dependencies
If you want to add a new dependency, the best way is to simply add it to the `requirements.txt` file.

### Django admin

Create a super user:

    python manage.py createsuperuser

Start the server and go to http://127.0.0.1:8000/admin/

### Browsable API
Start the server and go to http://127.0.0.1:8000/api/

### Deployment
The Django backend is hosted on Heroku at https://hompi-backend.herokuapp.com/.

To deploy a new version:

Install Heroku CLI.

Login:

    heroku login
    heroku container:login

Build and deploy Docker container:

    cd backend
    heroku container:push --app hompi-backend web
    heroku container:release --app hompi-backend web

Follow logs in real time:

    heroku logs --app=hompi-backend --tail

## Frontend (Flutter)

### Requirements

* [Flutter](https://flutter.dev/docs/get-started/install). Then run `flutter doctor` and follow the instructions.
### Setup

Install dependencies:

    cd frontend/hompi
    flutter pub get




