from django.urls import path

from . import views

urlpatterns = [
    path('', views.ListTask.as_view()),
    path('<int:pk>/', views.DetailTask.as_view()),
]
