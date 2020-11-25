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
              value: "10.2.1.0/24"
            - name: ROUTES
              value: "10.60.1.0/24"
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
              value: "172.16.2.0/24"
          resources:
            limits:
              networkservicemesh.io/socket: 1
        - name: firewall-container
          image: raffaeletrani/firewall_container:firewall
          securityContext:
            capabilities:
              add: ["NET_ADMIN"]
          command: ['/bin/sh', '-c', 'sleep infinity']
metadata:
  name: firewall
