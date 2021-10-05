## F.A.Q.

### What do I do to delete my world?
Dropping the whole composed stack and rebuilding it is generally the simplest way to do a full reset of the world since stopping and restarting the container will NOT change the world configuration.

```bash
WorldQLDocker/# docker-compose down -d -f ./docker-compose.yml
WorldQLDocker/# docker-compose up -d -f ./docker-compose.yml
```

OR 

```bash
WorldQLDocker/# docker-compose down -d -f ./docker-compose-manual.yml
WorldQLDocker/# docker-compose up -d -f ./docker-compose-manual.yml
```
