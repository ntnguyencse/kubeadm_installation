## Setup Private docker registry 
[Tutorial setup privvate docker registry](https://docs.docker.com/registry/deploying/)
```
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```