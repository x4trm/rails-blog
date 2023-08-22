FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y curl gnupg2 build-essential sudo
RUN apt-get install postgresql-contrib libpq-dev -y
RUN apt-get -y install patch bzip2 gawk g++ gcc autoconf automake bison libc6-dev libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libtool libyaml-dev make patch pkg-config sqlite3 zlib1g-dev libgmp-dev libreadline-dev libssl-dev
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN apt-get install libfontconfig libxrender1 libjpeg-turbo8 wkhtmltopdf -y

RUN apt install npm -y
RUN npm install yarn -g
RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

RUN useradd -rm -d /home/hosting -u 1001 -g root -s /bin/bash hosting
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER hosting
WORKDIR /home/hosting/blog

SHELL ["/bin/bash","-c"]
RUN gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash
RUN echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile
RUN echo "export PATH=\"$PATH:$HOME/.rvm/bin\"" >> .bashrc
RUN  $HOME/.rvm/bin/rvm install 3.1.0 --autolibs=read-only
ENV PATH  = "$HOME/.rvm/bin:$HOME/.rvm/rubies/ruby-3.1.0:${PATH}"

RUN  /bin/bash -l -c "rvm use --default 3.1.0"
RUN  /bin/bash -l -c "rvm use 3.1.0 && gem install bundler && gem install rails -v 7.0.1"
RUN  /bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' >  $HOME/.gemrc "
# COPY Gemfile /home/hosting/blog/blog
# COPY Gemfile.lock /home/hosting/blog
# RUN /bin/bash -l -c "bundle install"
EXPOSE 3000
CMD ["rails","server","-b","0.0.0.0"]