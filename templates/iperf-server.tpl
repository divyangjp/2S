---
apiVersion: apps/v1
kind: Deployment
spec:
  selector:
    matchLabels:
      networkservicemesh.io/app: "iperf-server"
      networkservicemesh.io/impl: "rfchain"
  replicas: 1
  template:
    metadata:
      labels:
        networkservicemesh.io/app: "iperf-server"
        networkservicemesh.io/impl: "rfchain"
    spec:
      serviceAccount: skydive-service-account
      containers:
        - name: iperf3-server
          image: networkstatic/iperf3
          securityContext:
            capabilities:
              add: ["NET_ADMIN"]
          args: ['-s']
          ports:
          - containerPort: 5201
            name: server
            protocol: TCP
      terminationGracePeriodSeconds: 0
metadata:
  name: iperf-server
  annotations:
    ns.networkservicemesh.io: rfchain/sgi0?link=sgi
