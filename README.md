# hompi
Home Planner by Hisingen Heavy Metal Squad

## Backend (Django)
### Requirements
* Python 3
* pip

### Setup

Create a virtual Python environment:

    python -m venv backend

Activate virtual Python environment:

    source backend/bin/activate

Change to `src` directory:

    cd backend/src

Install Python dependencies:

    pip install -r requirements.txt

Start Django server:

    python manage.py runserver

Run Database migrations:

    python manage.py migrate

### Database migrations

Create migrations after you have made model changes (don't forget to run the migrations afterwards):

    python manage.py makemigrations api

### Django admin

Create a super user:

    python manage.py createsuperuser

Start the server and go to http://127.0.0.1:8000/admin/

### Browsable API
Start the server and go to http://127.0.0.1:8000/api/

## Frontend (Flutter)

### Requirements

* Flutter
### Setup

Install dependencies:

    cd frontend/hompi
    dart pub get

