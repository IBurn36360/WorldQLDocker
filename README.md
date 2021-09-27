# WorldQLDocker
**FOR DEVELOPMENT PURPOSES ONLY**

Dockerfile and scripts for WorldQL.

## To use

```bash
git clone https://github.com/WorldQL/WorldQLDocker/
cd WorldQLDocker/
docker build -t worldql-0.02-alpha .
docker run -dt --network="host" worldql-0.02-alpha
```
