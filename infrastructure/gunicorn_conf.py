# Non logging stuff
bind = ":8000"
workers = 2
# Access log - records incoming HTTP requests
accesslog = "/app/gunicorn_access.log"
# Error log - records Gunicorn server goings-on
errorlog = "/app/gunicorn_error.log"
# Whether to send Django output to the error log
capture_output = True
# How verbose the Gunicorn error logs should be
loglevel = "info"
