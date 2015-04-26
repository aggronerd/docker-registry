FROM ubuntu

RUN apt-get update
RUN apt-get -y install build-essential python-dev libevent-dev python-pip liblzma-dev nginx apache2-utils swig openssl libssl-dev
RUN pip install docker-registry

RUN cp /usr/local/lib/python2.*/dist-packages/config/config_sample.yml /tmp/config.yml
RUN cp /tmp/config.yml /usr/local/lib/python2.*/dist-packages/config/
RUN mkdir /var/docker-registry
RUN mkdir -p /var/docker-registry/log

ENV STORAGE_PATH=/var/docker-registry/registry
ENV SQLALCHEMY_INDEX_DATABASE=sqlite:////var/docker-registry/docker-registry.db

ADD resources/upstart /etc/init/docker-registry.conf
ADD resources/docker-registry.htpasswd /etc/nginx/docker-registry.htpasswd
ADD resources/docker-registry.site /etc/nginx/sites-available/docker-registry
RUN ln -s /etc/nginx/sites-available/docker-registry /etc/nginx/sites-enabled/docker-registry

ADD resources/docker.doran.me.uk.crt /etc/ssl/certs/docker-registry
ADD resources/docker.doran.me.uk.key /etc/ssl/private/docker-registry
RUN sudo service nginx restart

VOLUME /var/docker-registry
ENTRYPOINT ["gunicorn", "--access-logfile", "/var/docker-registry/log/access.log", "--error-logfile", "/var/log/docker-registry/server.log", "-k", "gevent", "-b", "localhost:5000", "--max-requests", "100", "--graceful-timeout", "3600", "-t", "3600", "-w", "8", "docker_registry.wsgi:application"] 
