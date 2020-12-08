---
apiVersion: apps/v1
kind: Deployment
spec:
  selector:
    matchLabels:
      networkservicemesh.io/app: "firewall"
      networkservicemesh.io/impl: "rfchain"
  replicas: 1
  template:
    metadata:
      labels:
        networkservicemesh.io/app: "firewall"
        networkservicemesh.io/impl: "rfchain"
    spec:
      serviceAccount: skydive-service-account
      containers:
        - name: sidecar-nse
          image: networkservicemesh/proxy-sidecar-nse:master
          imagePullPolicy: IfNotPresent
          env:
            - name: ENDPOINT_NETWORK_SERVICE
              value: "rfchain"
            - name: ENDPOINT_LABELS
              value: "app=iperf-server"
            - name: IP_ADDRESS
              value: "10.60.2.0/24"
          resources:
            limits:
              networkservicemesh.io/socket: 1
        - name: ep-to-router
          #image: raffaeletrani/sidecar-nse
          image: networkservicemesh/proxy-sidecar-nse:master
          imagePullPolicy: IfNotPresent
          env:
            - name: ENDPOINT_NETWORK_SERVICE
              value: "rfchain"
            - name: ENDPOINT_LABELS
              value: "app=firewall"
            - name: IP_ADDRESS
              value: "10.60.3.0/24"
          resources:
            limits:
              networkservicemesh.io/socket: 1
        - name: firewall-container
          image: divyangjp/firewall:k8s
          securityContext:
            capabilities:
              add: ["NET_ADMIN"]
          command: ['/bin/sh', '-c', 'sleep infinity']
        - name: router
          image: networkservicemesh/topology-qrtr:master
          imagePullPolicy: IfNotPresent
          securityContext:
            capabilities:
              add: ["NET_ADMIN"]
          volumeMounts:
            - name: startup-config
              mountPath: /etc/quagga/zebra.conf
              subPath: zebra.conf
            - name: ospf-config
              mountPath: /etc/quagga/ospf.conf
              subPath: ospf.conf
      volumes:
        - name: startup-config
          configMap:
            name: qrtr-2
        - name: ospf-config
          configMap:
            name: qrtr-2-ospf-config
metadata:
  name: firewall
---
apiVersion: v1
metadata:
  name: qrtr-2
data:
  zebra.conf: |
    !
    hostname qrtr-2
    !
    interface lo
      ip address 192.0.3.1/32
    !
    ip forwarding
    exit
kind: ConfigMap
---
apiVersion: v1
metadata:
  name: qrtr-2-ospf-config
data:
  ospf.conf: |
    !
    router ospf
     network 0.0.0.0/0 area 0.0.0.0
     passive-interface eth0
     log stdout debugging
    !
kind: ConfigMap
