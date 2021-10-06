## Manual Composed Stack
(For use when you want to test full stack deployment with internal networking and/or want tools to inspect the database with a locally built version of the plugin).
```bash
WorldQLDocker/# docker-compose up -d -f ./docker-compose.manual.yml
```

To rebuild the container without having to delete the old image, you may alternatively run the following.  After running this, you MUST start the service independently.
```bash
WorldQLDocker/# docker-compose up -d -f ./docker-compose.manual.yml --no-deps --build client-minecraft-server
```

### [F.A.Q.](./DockerFAQ.md)
