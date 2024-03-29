FROM amd64/ubuntu:18.04
#FROM node:8.9.4

# Install app dependencies


#FROM node:8.9.4

RUN apt update -y

# Install wget
RUN apt install wget -y

#WORKDIR /tmp
#RUN wget https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.gz && \
#tar -xvf node-v8.9.4-linux-x64.tar.gz && \
#cd node-v8.9.4-linux-x64 * && \
#./configure && \
#make -jX && \
#make install

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

ENV NVM_DIR  /.nvm
ENV NODE_VERSION 8.9.4

# Install nvm with node and npm
RUN mkdir $NVM_DIR && curl https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

#ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
#ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN command -v npm

#RUN apt install libstdc++6

RUN strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX


RUN npm install -g node-pre-gyp babel-cli steal-tools


#Install wkhtmltopdf dependencies
#RUN wget http://launchpadlibrarian.net/340453609/libjpeg-turbo8_1.5.2-0ubuntu5_amd64.deb
#RUN dpkg -i libjpeg-turbo8_1.5.2-0ubuntu5_amd64.deb


#RUN wget http://mirrors.kernel.org/ubuntu/pool/main/z/zlib/zlib1g_1.2.11.dfsg-0ubuntu2_amd64.deb
#RUN dpkg -i zlib1g_1.2.11.dfsg-0ubuntu2_amd64.deb

#RUN wget http://security.ubuntu.com/ubuntu/pool/main/libp/libpng1.6/libpng16-16_1.6.34-1ubuntu0.18.04.1_amd64.deb
#RUN dpkg -i libpng16-16_1.6.34-1ubuntu0.18.04.1_amd64.deb

#RUN wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4.3_amd64.deb
#RUN dpkg -i libssl1.1_1.1.0g-2ubuntu4.3_amd64.deb

#RUN wget http://mirrors.kernel.org/ubuntu/pool/main/libf/libfontenc/libfontenc1_1.1.3-1_amd64.deb
#RUN dpkg -i libfontenc1_1.1.3-1_amd64.deb

#RUN wget http://mirrors.kernel.org/ubuntu/pool/main/x/xfonts-encodings/xfonts-encodings_1.0.4-2_all.deb
#RUN dpkg -i xfonts-encodings_1.0.4-2_all.deb

#RUN wget http://mirrors.kernel.org/ubuntu/pool/main/x/xfonts-utils/xfonts-utils_7.7+6_amd64.deb
#RUN dpkg -i xfonts-utils_7.7+6_amd64.deb

#RUN wget http://mirrors.kernel.org/ubuntu/pool/universe/x/xfonts-75dpi/xfonts-75dpi_1.0.4+nmu1_all.deb
#RUN dpkg -i xfonts-75dpi_1.0.4+nmu1_all.deb

#RUN apt install libjpeg-turbo libpng-dev libssl-dev xfonts* -y

#RUN wget http://mirrors.kernel.org/ubuntu/pool/main/x/xfonts-base/xfonts-base_1.0.4+nmu1_all.deb
#RUN dpkg -i xfonts-base_1.0.4+nmu1_all.deb

#RUN wget http://ftp.us.debian.org/debian/pool/main/libm/libmspack/libmspack0_0.10.1-1_amd64.deb
#RUN dpkg -i libmspack0_0.10.1-1_amd64.deb

#RUN wget http://ftp.us.debian.org/debian/pool/main/c/cabextract/cabextract_1.9-2_amd64.deb
#RUN dpkg -i cabextract_1.9-2_amd64.deb

#RUN wget http://ftp.us.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.7_all.deb
#RUN dpkg -i ttf-mscorefonts-installer_3.7_all.deb


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
RUN wget https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb
RUN dpkg -i wkhtmltox_0.12.5-1.bionic_amd64.deb

WORKDIR /usr/app/src
COPY . .

WORKDIR /usr/app/src/DAT
RUN npm install
WORKDIR /usr/app/src/DAT/js
RUN npm install bootstrap
WORKDIR /usr/app/src/DAT
RUN npm run build
WORKDIR /usr/app/src/DAT
RUN npm run build:server


EXPOSE 3000

CMD [ "npm", "start" ]
