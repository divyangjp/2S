---
apiVersion: apps/v1
kind: Deployment
spec:
  selector:
    matchLabels:
      networkservicemesh.io/app: "iperf-client"
      networkservicemesh.io/impl: "servicechain"
  replicas: 1
  template:
    metadata:
      labels:
        networkservicemesh.io/app: "iperf-client"
        networkservicemesh.io/impl: "servicechain"
    spec:
#      hostPID: true
#      hostNetwork: true
#      dnsPolicy: ClusterFirstWithHostNet
      serviceAccount: skydive-service-account
      #affinity:
      #    nodeAffinity:
      #        requiredDuringSchedulingIgnoredDuringExecution:
      #            nodeSelectorTerms:
      #                - matchExpressions:
      #                  - key: kubernetes.io/hostname
      #                    operator: In
      #                    values:
      #                      - cube2
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
  namespace: default
  annotations:
    ns.networkservicemesh.io: servicechain
