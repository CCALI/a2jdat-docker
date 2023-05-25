FROM amd64/ubuntu:22.04
#FROM node:8.9.4

# Install app dependencies

RUN apt update -y

# Install wget
RUN apt install wget -y

# Install base dependencies
RUN apt-get update && apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        wget \
    && rm -rf /var/lib/apt/lists/*


RUN strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX


#RUN npm install -g node-pre-gyp babel-cli steal-tools


#RUN apt update && \
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | \
debconf-set-selections && \
apt update && \
apt install -y ttf-mscorefonts-installer

#RUN apt update && \
#dpkg -i ttf-mscorefonts-installer_3.7_all.deb

RUN apt install fontconfig -y && fc-cache -f -v

RUN apt install -y libjpeg-turbo8 libx11-6 libxcb1 libxext6 libxrender1 xfonts-75dpi xfonts-base

# Install wkhtmltopdf
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb
RUN dpkg -i wkhtmltox_0.12.6.1-2.jammy_amd64.deb


WORKDIR /usr/app/src/
RUN git clone https://github.com/ccali/a2jdat
WORKDIR /usr/app/src/a2jdat


# since we're starting non-interactive shell, 
# we wil need to tell bash to load .bashrc manually
ENV BASH_ENV ~/.bashrc
# needed by volta() function
ENV VOLTA_HOME /root/.volta
# make sure packages managed by volta will be in PATH
ENV PATH $VOLTA_HOME/bin:$PATH
RUN curl https://get.volta.sh | bash
RUN volta install node
RUN volta install node-pre-gyp babel-cli steal-tools


RUN npm run deploy


EXPOSE 3000

CMD [ "npm", "start" ]
