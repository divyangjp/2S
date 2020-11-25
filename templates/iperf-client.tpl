---
apiVersion: apps/v1
kind: Deployment
spec:
  selector:
    matchLabels:
      networkservicemesh.io/app: "iperf-client"
      networkservicemesh.io/impl: "rfchain"
  replicas: 1
  template:
    metadata:
      labels:
        networkservicemesh.io/app: "iperf-client"
        networkservicemesh.io/impl: "rfchain"
    spec:
#      hostPID: true
#      hostNetwork: true
#      dnsPolicy: ClusterFirstWithHostNet
      serviceAccount: skydive-service-account
      containers:
      - name: iperf3-client
        image: networkstatic/iperf3
        securityContext:
          capabilities:
            add: ["NET_ADMIN"]
        command: ['/bin/sh', '-c', 'sleep infinity']
      terminationGracePeriodSeconds: 0
metadata:
  name: iperf-client
  annotations:
    ns.networkservicemesh.io: rfchain/c1r1?link=c1r
