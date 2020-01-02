Plan:
* create a cluster using K8s and deploy in it helm/tiller
* find an implementation of a LoadBalancer that you can use in a local implementation - how about metallb? - https://mauilion.dev/posts/kind-metallb/
* deploy redis in the cluster using helmsman and try to configure it to be accessible from outside the cluter
* learn about the different redis setups (sentinel, master, slaves)


Install:
* go - https://linuxize.com/post/how-to-install-go-on-ubuntu-18-04/
* docker - https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04 (remember to follow step 2 as well to have Docker running without sudo)
* kubectl - https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
* kind - GO111MODULE="on" go get sigs.k8s.io/kind@v0.6.1
* add bin from go install and the local go bin to the PATH - `export PATH=$PATH:/usr/local/go/bin:/home/parallels/go/bin`
* helm - https://helm.sh/docs/intro/install/
* helm-diff - `helm init` and `helm plugin install https://github.com/databus23/helm-diff --version master`
* helmsman - https://github.com/Praqma/helmsman#from-binary
* jid - cool REPL for JSON - `sudo apt install jid`
* Install redis-cli only by building it from source: https://codewithhugo.com/install-just-redis-cli-on-ubuntu-debian-jessie/

Steps:
* Determine the network used for the node IP pool - `docker network inspect bridge | jid` and go to `.[0].IPAM` and in my case it will be `172.17.0.0/16`
* Install a service like echo service - `kubectl run echo --image=inanimate/echo-server --replicas=3 --port=8080`
* Expose the service as LoadBalancer: `kubectl expose deployment echo --type=LoadBalancer`
* Deploy metallb - https://metallb.universe.tf/installation/ - `kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml`
* Apply the `metallb-config.yaml` and check that an IP is assigned to the echo service.
* Create serviceaccount for tiller: `kubectl create serviceaccount -n kube-system tiller` - https://github.com/helm/helm/issues/5100
* Create clusterrole binding between the clusterrole `cluster-admin` and serviceaccount `tiller`: `kubectl create clusterrolebinding tiller-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:tiller`
* Update tiller deployment to use the new service account: `kubectl --namespace kube-system patch deploy tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'`

Non-prod:
* create secret with redis password
* install redis using the stable chart and customise the values, especially the `cluster: false`, existingSecret values to point to the existing secret with the password and make sure that the master service type is LoadBalancer (there are other settings to customise, but will see on stop) - https://github.com/helm/charts/tree/master/stable/redis
* Verify that the redis service has an external IP
* Verify that we can connect to the redis instance using the CLI: `redis-cli -h 172.17.255.2 -p 6379 -a test ping` - https://redis.io/topics/rediscli

Prod:
Just create a headless service and use an Endpoints resource to point to the remote one.