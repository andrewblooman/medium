# Use the node:19-alpine image as the base image
FROM node:19-alpine
 
# Set the UID and GID for the user and group that will run the Node.js app
ARG UID=1000
ARG GID=1000
 
# Create the user and group with the specified UID and GID
RUN addgroup -S app && adduser -S -u ${UID} -g ${GID} app
 
# Create app directory & set default dir so that next commands executes in /usr/app dir, liked cd-ing into /usr/app to execute npm install
WORKDIR /usr/app
 
# Copy package.json, wildcard used so both package.json AND package-lock.json are copied # slash '/' at the end of app is important, so it created an app directory, otherwise you'll get an error
COPY package*.json /usr/app/
 
# Copy app files from src directory
COPY src /usr/app/
 
# Install the dependencies
RUN npm install
 
# Set the entrypoint to run the Node.js app as the app user
USER app
ENTRYPOINT ["npm", "start"]