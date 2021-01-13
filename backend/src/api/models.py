from django.db import models

class Task(models.Model):
    title = models.CharField(max_length=200)

    def __str__(self):
        """A string representation of the model."""
        return self.title
