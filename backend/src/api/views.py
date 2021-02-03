from rest_framework import generics
from .models import Task
from .serializers import TaskSerializer
from django.contrib.auth.mixins import LoginRequiredMixin

class ListTask(LoginRequiredMixin,generics.ListCreateAPIView):
    serializer_class = TaskSerializer

    def get_queryset(self):
        return Task.objects.filter(user=self.request.user).order_by("due_date")

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class DetailTask(LoginRequiredMixin,generics.RetrieveUpdateDestroyAPIView):
    serializer_class = TaskSerializer

    def get_queryset(self):
        return Task.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
