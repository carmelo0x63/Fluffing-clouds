# goweb, a simple Go responder application

----

## Experiments in K3s
### What's in a `pod`
Our cluster has just been deployed. Nothing is running in the user namespaces:
```
$ kubectl get pods -o wide
No resources found in default namespace.
```

Let's start by applying `goweb-pod.yaml`:
```
<user>@pico1 $ kubectl apply -f goweb-pod.yaml
pod/goweb-pod created
```

A **pod** is deployed and it is sent to one of the available nodes in the cluster:
```
<user>@pico1 $ kubectl get pods -o wide
NAME        READY   STATUS              RESTARTS   AGE   IP       NODE    NOMINATED NODE   READINESS GATES
goweb-pod   0/1     ContainerCreating   0          5s    <none>   pico5   <none>           <none>

<user>@pico1 $ kubectl get pods -o wide
NAME        READY   STATUS    RESTARTS   AGE   IP          NODE    NOMINATED NODE   READINESS GATES
goweb-pod   1/1     Running   0          39s   10.42.4.3   pico5   <none>           <none>
```
**NOTE**: the pod is also assigned an IP address (10.42.4.3) and is connected to an internal network spanning the whole cluster.

What happens underneath is that the pod is running a containerized application listening locally on port 8080:
```
<user>@pico1 $ kubectl exec --stdin --tty goweb-pod -- netstat -tulpn
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 :::8888                 :::*                    LISTEN      1/main.go
```

From a different node (within the same cluster), let's try and reach the application:
```
<user>@pico1 $ curl http://10.42.4.3:8888/Hello\!
This is goweb-pod running on linux/arm64 saying: Hello!
```

### Introducing `services`
This is quite good, just not enough. In fact, the application is reachable **within** the cluster not from outside clients. For that magic to happen, we need a *service*:
```
<user>@pico1 $ kubectl get services -o wide
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE   SELECTOR
kubernetes   ClusterIP   10.43.0.1    <none>        443/TCP   50m   <none>

<user>@pico1 $ kubectl apply -f goweb-svc.yaml
service/goweb-svc created

<user>@pico1 $ kubectl get services -o wide
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE   SELECTOR
kubernetes   ClusterIP   10.43.0.1      <none>        443/TCP        51m   <none>
goweb-svc    NodePort    10.43.244.13   <none>        80:31234/TCP   3s    version=v1,zone=prod
```

A service has been deployed that exposes our application on a specified port (31234). Consequently, the application becomes reachable form an outside network:
```
<user1>@client $ curl http://<public_ip_address>:31234/Hello\!
This is goweb-pod running on linux/arm64 saying: Hello!
```

In a complex scenario, how does the service link the right pod to the right port? That happens by means of "labels" (attached to the pods):
```
$ kubectl describe pods goweb-pod | grep -A3 ^Labels
Labels:           dummy=abc
                  version=v1
                  zone=prod
Annotations:      <none>
```

and "selectors" (used by the services to select any pods):
```
$ kubectl describe services goweb-svc | grep Selector
Selector:                 version=v1,zone=prod
```
**NOTE**: the service will try and match _all_ of the selectors it's been configured with, in a logical AND fashion. If one mismatch occurs, the service will not link to the pod.

### `deployments`
