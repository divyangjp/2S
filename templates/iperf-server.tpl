---
apiVersion: apps/v1
kind: Deployment
spec:
  selector:
    matchLabels:
      networkservicemesh.io/app: "iperf-server"
      networkservicemesh.io/impl: "servicechain"
  replicas: 1
  template:
    metadata:
      labels:
        networkservicemesh.io/app: "iperf-server"
        networkservicemesh.io/impl: "servicechain"
    spec:
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
        - name: sidecar-nse
          image: networkservicemesh/proxy-sidecar-nse:master
          imagePullPolicy: IfNotPresent
          env:
            - name: ENDPOINT_NETWORK_SERVICE
              value: "servicechain"
            - name: ENDPOINT_LABELS
              value: "app=iperf-server"
            - name: IP_ADDRESS
              value: "172.16.2.0/24"
          resources:
            limits:
              networkservicemesh.io/socket: 1
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
  namespace: default
