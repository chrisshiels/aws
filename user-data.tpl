#cloud-config


runcmd:
  - touch /hello
  - yum -y install httpd
  - echo "<html><body>`hostname`</body></html>" > /var/www/html/index.html
  - service httpd start

# Note:
# Python's SimpleHTTPServer didn't interact well with ELB health checks - it's
# single threaded and would block waiting on input from the health check...
#  - mkdir /app
#  - cd /app
#  - echo "<html><body>hello from `hostname`</body></html>" > index.html
#  - python -m SimpleHTTPServer 8000 &
