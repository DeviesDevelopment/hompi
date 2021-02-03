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

### Database migrations

Create migrations after you have made model changes (don't forget to restart the container afterwards):

    python manage.py makemigrations api

### Adding dependencies
If you add a new dependency, remember to run:

    pip freeze > requirements.txt

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

    heroku container:push --app hompi-backend web
    heroku container:release --app hompi-backend web

## Frontend (Flutter)

### Requirements

* [Flutter](https://flutter.dev/docs/get-started/install). Then run `flutter doctor` and follow the instructions.
### Setup

Install dependencies:

    cd frontend/hompi
    flutter pub get




