# WorldQLDocker
**FOR DEVELOPMENT PURPOSES ONLY**

Docker-based virtualized development and testing tools for WorldQL.

## Cloning the repo
```bash
~/# git clone https://github.com/WorldQL/WorldQLDocker/
~/# cd WorldQLDocker/
```

## Installing the helper tools
You will need the following:
- [Docker](https://docs.docker.com/get-docker/)
- [Kubernetes](https://kubernetes.io/docs/setup/) (Optional)

It is HIGHLY recommended you spend time understanding what these tools are and what they do before trying to use them or trying to work with them.

## To use
__All use cases described below assume you have cloned this repository and are in the root directory for the repository.__

Links to dedicated guides (All shell code blocks will state what directory you should be in on each command line):
 - [Standalone Control Plane with DB](./Guides/Standalone.md)
 - [Docker Compose (Using the public release)](./Guides/DockerCompose.md)
 - [Kubernetes Stack](./Guides/Kubernetes.md)
 
## F.A.Q.

### The progress database isn't starting?
You likely didn't generate the environment for your compose setup, or didn't set the secrets for your Kubernetes stack properly.  Please ensure that you generated database credentials using the method applicable to your stack.

### I'm getting "No such file or directory ." errors on the control plane and/or the client server.  What went wrong?
You cloned the repository incorrectly.  More specifically, your script files for the Docker have carriage returns (CR), which breaks every script.  Please correct the line endings by either following the applicable guide for turning off auto conversion for your OS, or going in and manually setting the files to have line feeds as their line endings.

### I'm still not able to connect, but the client server appears to be running.  Why?
In some cases, you will have another process listening on port `25565`.  The simplest way to manage this is to chanbge the port binding for the client server from `25565` to an open port, like `25570`.  the result in this example would be `"25570:25565"`, bearing in mind that `25570` could be ANY available port.

