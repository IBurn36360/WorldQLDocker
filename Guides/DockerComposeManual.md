## Manual Composed Stack
(For use when you want to test full stack deployment with internal networking and/or want tools to inspect the database with a locally built version of the plugin).

Before you can run this compose file, you MUST provide a manual build of the Mammoth client plugin into the path `~WorldQLDocker/Docker/ClientServer/WorldQLClient.jar`.

```bash
WorldQLDocker/# docker-compose -f ./docker-compose.manual.yml up -d
```

To rebuild the container without having to delete the old image, you may alternatively run the following.  After running this, you MUST start the service independently.
```bash
WorldQLDocker/# docker-compose -f ./docker-compose.manual.yml up -d --no-deps --build client-minecraft-server
```

### [F.A.Q.](./DockerFAQ.md)
