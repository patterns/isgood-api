# local isgood_webAPI
This is a Docker image of the isgood API service.
  It's a way to emulate AWS offline during development, validate/testing.
  If you have Python 3.8 (at the time Chalice expects 3.8 because that's the version
  in AWS deployment) and venv, you have the tools already.
  This is really a setup for when your workstation doesn't have the prerequisites,
  or like me, you're constantly installing different tools and risk contaminating
  your environment.


> [isgood API](https://github.com/for-good/isgood-api)

## Quickstart
1. Install [Docker](https://docker.com/)
2. Git clone the [Dockerfile](https://github.com/for-good/isgood-api.git)
3. Build container, and run: 

```console
$ docker build -f isgood-api/cmd/server/chalice.Dockerfile -t isgood isgood-api/cmd/server
$ docker run -ti -p 8000:8000 isgood
$ curl http://localhost:8000/recommendations?criteria=ipsum,lorem,bacon
```

Use volume mounting to work on files:
- New project example, ```docker run -ti -v $PWD:/mysrc -w /mysrc isgood chalice new-project myproj```
- Run tests example, ```docker run -ti -v $PWD/isgood-api:/mysrc -w /mysrc isgood py.test cmd/server/tests/test_app.py```
- CloudFormation example, ```docker run -ti -v $PWD/isgood-api:/mysrc -w /mysrc/cmd/server isgood chalice package out/```




## Credits

Chalice 
 [quickstart](https://aws.github.io/chalice/)

