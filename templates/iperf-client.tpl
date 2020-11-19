---
apiVersion: apps/v1
kind: Deployment
spec:
  selector:
    matchLabels:
      networkservicemesh.io/app: "iperf-client"
      networkservicemesh.io/impl: "example"
  replicas: 1
  template:
    metadata:
      labels:
        networkservicemesh.io/app: "iperf-client"
        networkservicemesh.io/impl: "example"
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
    ns.networkservicemesh.io: example/nsm11
