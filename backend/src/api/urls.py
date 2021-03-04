from django.urls import include, path

from . import views

urlpatterns = [
    path('', views.ListTask.as_view()),
    path('<int:pk>/', views.DetailTask.as_view()),
    path('dj-rest-auth/', include('dj_rest_auth.urls')),
]
