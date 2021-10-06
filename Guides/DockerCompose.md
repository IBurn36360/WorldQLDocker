## Composed Stack
(For use when you want to test full stack deployment with internal networking and/or want tools to inspect the database).

Start off by making sure you generate an environment file by running the generateEnvironment script and following the instructions.
```bash
WorldQLDocker/# generateEnvironment.sh
```

This compose stack supports providing your own plugins at build time.  If you wish to test Mammoth's interaction with certain plugins, or want to provide your own version of Mammoth, place them into `~WorldQLDocker/Docker/ClientServer/plugins/` and they will be copied into the container.
```bash
WorldQLDocker/# docker-compose -f ./docker-compose.yml up -d
```

### [F.A.Q.](./DockerFAQ.md)
