# docker run --rm -it -v /dev/vboxdrv:/dev/vboxdrv 
FROM ubuntu:20.04
ENV TZ=America/New_York
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y wget virtualbox ruby ruby-dev git zlib1g-dev
RUN gem install test-kitchen berkshelf bundler kitchen-vagrant
RUN wget https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.deb && dpkg -i vagrant_2.2.9_x86_64.deb && rm vagrant_2.2.9_x86_64.deb
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 755 /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
