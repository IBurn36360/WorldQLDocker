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

### Things...appear to be working?  How do I connect to the Minecraft server though?
The standalone image only sets up and runs the database and control plane.  It does not actually create a Minecraft server for you to connect to.  You will still need to create a Minecraft server using `Spigot/Paper/{INSERT FORK HERE}`, with the plugin added to that server, on your local machine, run that server and connect to it in order to see Mammoth in action.  If you don't want to go through this kind of effort, it is suggested that you stop the standalone docker container and use one of the composed guides listed in the root README.
