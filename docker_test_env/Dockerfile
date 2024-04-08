# docker run --rm -it -v /dev/vboxdrv:/dev/vboxdrv
ARG BASE_IMAGE=ubuntu:20.04
FROM $BASE_IMAGE
ARG TZ=America/New_York
ARG RUBY_VERSION=2.6.3

ENV TZ=$TZ
ENV RUBY_VERSION=$RUBY_VERSION
ENV DEBIAN_FRONTEND=noninteractive

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y wget virtualbox git zlib1g-dev curl

# RVM
RUN gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable

RUN /bin/bash -l -c "rvm requirements" # || cat /usr/local/rvm/log/*/*.log && false
RUN /bin/bash -l -c "rvm install ${RUBY_VERSION} && rvm cleanup all"
RUN /bin/bash -l -c "gem install bundler:2.3.26 --no-document"

RUN /bin/bash -l -c "gem install nori:2.6.0 test-kitchen:2.7.2 octokit:4.18.0 semverse:3.0.0 chef:14.10.9 berkshelf:7.0.10 kitchen-vagrant:1.7.0"
RUN wget https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.deb && dpkg -i vagrant_2.2.9_x86_64.deb && rm vagrant_2.2.9_x86_64.deb
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 755 /usr/bin/entrypoint.sh
ENTRYPOINT ["/bin/bash", "-l", "-c", "/usr/bin/entrypoint.sh"]
