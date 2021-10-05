## Standalone control plane
(For use when you want to test servers directly, usually when working with the server plugin).
```bash
WorldQLDocker/# cd Docker 
Docker/# docker build -t worldql-dev-standalone-db-cp:local standaloneDBControlPlane.dockerfile
Docker/# docker run -dt --network="host" worldql-dev-standalone-db-cp:local
```

---

## F.A.Q.
### Why host mode networking?
The standalone image is designed to work as if it was "part" of your computer, and expects everything to be resolved at `127.0.0.1`.  This means that nothing will work or respond properly when you go to add your local server(s) without it.
