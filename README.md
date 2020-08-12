## Kong Bug on 2.1.x

This bug is tested on Kong version 2.1.0 and 2.1.1 where Kong returns a response that does not belong to a request. This is caused when we have unhealthy pods in the system or all pods are in a rolling upgrade.

## Steps to reproduce

This is a minimal ruby example that replicates our production environment.
First, make sure you have Ruby installed on your system.

1. Install deps with `bundle install`
2. Install k8s with your solution, either minikube or docker for desktop
3. Build the docker image
4. Deploy Kong with helm or any installation method to the cluster
5. Deploy the deployment, the service and the ingress to the cluster

In this example you can find:
1. app.rb -> where the web server lives, simple echo server written in ruby. In this server, I also have an endpoint to simulate unhealthy pod.
2. request.rb -> the script we will be using to spam requests to the server. Please make sure you change the ip address of the server and the port, according to your k8s set up. Here I used minikube so that url can be achieved via:
```
minikube service -n example kong-kong-proxy --url
```
3. Other files for deployment to k8s like dockerfile and manifests

Reproduce the issue by:
1. First make sure that kubectl get pods returning all the pods at running state
2. Second make sure that you can make GET request to the server
3. Spam request with `bundle exec ruby request.rb`

The result should be consistent: you will see the script stop and output a response that doesnt belong to a request
