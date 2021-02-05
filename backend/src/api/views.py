from rest_framework import generics

from .models import Task
from .serializers import TaskSerializer

class ListTask(generics.ListCreateAPIView):
    queryset = Task.objects.all().order_by("due_date")
    serializer_class = TaskSerializer

    def get_queryset(self):
        return Task.objects.filter(user=self.request.user).order_by("due_date")

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class DetailTask(generics.RetrieveUpdateDestroyAPIView):
    queryset = Task.objects.all()
    serializer_class = TaskSerializer
