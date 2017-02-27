FROM node:boron

RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties
RUN apt-add-repository ppa:swi-prolog/stable

RUN apt-get install -y swi-prolog



# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install
RUN npm install node-repl -g
#RUN npm install -g localtunnel

# Bundle app source
COPY . /usr/src/app

EXPOSE 5000


#CMD lt -s $subdomain -p 5000 -l $ip & npm start

CMD ["npm", "start"]
