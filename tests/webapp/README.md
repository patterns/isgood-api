# testing the webapp NodeJS backend
To help verify the event-invoke final logic required to return DS result back to the webapp and make the POST request to the webapp NodeJS backend endpoint.

NOTE: since the API gateway is not a local instance, it isn't possible to have a developer send POST requests to a "localhost:8000" webapp backend because this would mean the API gateway would make HTTP connection to "itself". To actually verify the webapp backend endpoint, we would need a AWS deployed version of the webapp.


See reference for explanations about the docker-compose configuration

