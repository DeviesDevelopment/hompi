from rest_framework import serializers
from .models import Task

# Serializer translates our data into a JSON format
class TaskSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'id',
            'title',
            'due_date',
            'interval',
        )
        model = Task
