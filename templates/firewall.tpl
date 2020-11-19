---
apiVersion: apps/v1
kind: Deployment
spec:
  selector:
    matchLabels:
      networkservicemesh.io/app: "firewall"
      networkservicemesh.io/impl: "servicechain"
  replicas: 1
  template:
    metadata:
      labels:
        networkservicemesh.io/app: "firewall"
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
          image: raffaeletrani/sidecar-nse
          imagePullPolicy: IfNotPresent
          env:
            - name: ENDPOINT_NETWORK_SERVICE
              value: "servicechain"
            - name:  ENDPOINT_LABELS
              value: "app=firewall"
            - name: IP_ADDRESS
              value: "172.16.1.0/24"
            - name: NSM_NAMESPACE
              value: "nsm-system"
            - name: CLIENT_NETWORK_SERVICE
              value: "servicechain"
            - name: CLIENT_LABELS
              value: "app=firewall"
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
  namespace: default
