# docker run --rm -it -v /dev/vboxdrv:/dev/vboxdrv 
ARG BASE_IMAGE=ubuntu:20.04
FROM $BASE_IMAGE
ARG TZ=America/New_York
ARG RUBY_VERSION=2.6

ENV TZ=$TZ
ENV RUBY_VERSION=$RUBY_VERSION
ENV DEBIAN_FRONTEND=noninteractive

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y wget virtualbox git zlib1g-dev curl

# RVM
RUN gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install ${RUBY_VERSION} && rvm cleanup all"
RUN /bin/bash -l -c "gem install bundler --no-document"

RUN /bin/bash -l -c "gem install test-kitchen berkshelfbundler kitchen-vagrant"
RUN wget https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.deb && dpkg -i vagrant_2.2.9_x86_64.deb && rm vagrant_2.2.9_x86_64.deb
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 755 /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
