# Django command to wait for the database to be available
from django.core.management.base import BaseCommand
import time
from psycopg2 import OperationalError as Psycopg2Error
from django.db.utils import OperationalError


class Command(BaseCommand):

    def handle(self, *args, **options):
        self.stdout.write("Waiting for database...")
        db_up = False
        while db_up is False:
            try:
                self.check(databases=['default'])
                db_up = True
            except (Psycopg2Error, OperationalError):
                self.stdout.write(
                    self.style.ERROR(
                        'Database unavailable, waiting for 1 second...'))
                time.sleep(1)

        self.stdout.write(self.style.SUCCESS('Database available!'))
