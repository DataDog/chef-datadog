ARG BASE_IMAGE=ubuntu:20.04
FROM $BASE_IMAGE
ARG TZ=America/New_York
ARG RUBY_VERSION=2.6.3

ENV TZ=$TZ
ENV RUBY_VERSION=$RUBY_VERSION
ENV DEBIAN_FRONTEND=noninteractive

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y wget git zlib1g-dev curl gpg

# RVM
RUN gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable

RUN /bin/bash -l -c "rvm requirements" # || cat /usr/local/rvm/log/*/*.log && false
RUN /bin/bash -l -c "rvm install ${RUBY_VERSION} && rvm cleanup all"
RUN /bin/bash -l -c "gem install bundler:2.3.26 --no-document"

RUN /bin/bash -l -c "gem install nori:2.6.0 test-kitchen:2.7.2 octokit:4.18.0 semverse:3.0.0 chef:14.10.9 berkshelf:7.0.10 kitchen-vagrant:1.7.0 kitchen-docker:2.3.0"

# build with --build-arg INSTALL_VAGRANT=1 to get vagrant support (not needed for kitchen-docker-tests)
# requires `-v /dev/vboxdrv:/dev/vboxdrv` when running
ARG INSTALL_VAGRANT
RUN if [ -n "${INSTALL_VAGRANT}" ]; then \
    apt-get install -y virtualbox && wget https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.deb && dpkg -i vagrant_2.2.9_x86_64.deb && rm vagrant_2.2.9_x86_64.deb \
    ; fi

# Install docker. Requires `-v /var/run/docker.sock:/var/run/docker.sock` when running to use the host's docker daemon
RUN \
    apt-get update && \
    apt-get install -y ca-certificates && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 755 /usr/bin/entrypoint.sh

# Apply patch kitchen-docker to make it possible to manually override the hostname for docker
# with the `KITCHEN_DOCKER_HOSTNAME` environment variable, which is necessary when working on non-native docker.
COPY docker.rb.patch /
RUN patch -p1 -i /docker.rb.patch

# Helpful defaults to run kitchen tests
ENV DOCKER_BUILDKIT=0 \
    CIRCLE_NODE_TOTAL=1 \
    CIRCLE_NODE_INDEX=0 \
    CHEF_LICENSE=accept

ENTRYPOINT ["/bin/bash", "-l", "-c", "/usr/bin/entrypoint.sh"]
