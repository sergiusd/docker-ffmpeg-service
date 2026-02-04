FROM node:16-bullseye-slim

LABEL maintainer="Sergei Demchuk <sergiusdem@gmail.com>"

# FFmpeg
RUN apt-get update && \
    apt-get install -y ffmpeg git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src

# Custom Builds go here
RUN npm install -g fluent-ffmpeg

# Cleanup
WORKDIR /usr/local/
RUN rm -rf /usr/local/src

WORKDIR /work

# Make sure Node.js and FFmpeg are installed
RUN node -v && npm -v && ffmpeg -version

# Create app dir
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install Dependencies
COPY package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY . /usr/src/app

EXPOSE 3000
ENTRYPOINT []
CMD ["node", "app.js"]
