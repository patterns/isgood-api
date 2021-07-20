ARG ARCH=
FROM ${ARCH}node:lts 


RUN git clone --depth 1 \
        --branch development https://github.com/for-good/isgood.ai-backend \
        /opt/project

WORKDIR /app
RUN cp /opt/project/package*.json /app/
RUN npm ci
RUN cp -R /opt/project/* /app/
RUN chown -R node:node /app
USER node
EXPOSE 8000
CMD npm start
