FROM odoo:13.0
USER root
COPY ./odoo.conf /etc/odoo
RUN apt update
RUN apt install -y openssh-server git
RUN apt install -y certbot build-essential wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev swig libjpeg-dev zlib1g-dev
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade pyopenssl

USER odoo
