gunicorn --bind 0.0.0.0:5000 server:app -w 1 --threads 12
