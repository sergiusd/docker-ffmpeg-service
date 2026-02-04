FROM node:18-alpine

LABEL maintainer="Sergei Demchuk <sergiusdem@gmail.com>"

# FFmpeg
RUN apk add --no-cache ffmpeg git

# Create app directory
WORKDIR /usr/src/app

# Copy package files
COPY package.json package-lock.json* ./

# Install app dependencies
RUN npm ci --only=production || npm install --only=production

# Bundle app source
COPY . .

# Verify installations
RUN node -v && npm -v && ffmpeg -version

EXPOSE 3000
CMD ["node", "app.js"]
