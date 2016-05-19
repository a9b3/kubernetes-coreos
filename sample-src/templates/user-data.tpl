#cloud-config
# vim: set ft=yaml:

write-files:
  - path: /opt/bin/wupiao
    permission: 0755
    content: |
      #!/bin/bash
      # wait until port is actually open
      [ -n "$1" ] && \
        until curl -o /dev/null -sIf http://${1}; do \
          sleep 1 && echo .;
        done;
      exit $?

coreos:
  etcd2:
    #generate a new token for each unique cluster from https://discovery.etcd.io/new
    {{#if ETCD_DISCOVERY_TOKEN}}
    discovery: https://discovery.etcd.io/{{ETCD_DISCOVERY_TOKEN}}
    {{/if}}
    # multi-region and multi-cloud deployments need to use $public_ipv4
    advertise-client-urls: http://$public_ipv4:2379
    initial-advertise-peer-urls: http://$private_ipv4:2380
    # listen on both the official ports and the legacy ports
    # legacy ports can be omitted if your application doesn't depend on them
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-peer-urls: http://$private_ipv4:2380,http://$private_ipv4:7001
  fleet:
    public-ip: $public_ipv4
  flannel:
    interface: $public_ipv4
  units:
    - name: etcd2.service
      command: start
    - name: fleet.service
      command: start
    - name: flanneld.service
      drop-ins:
      - name: 50-network-config.conf
        content: |
          [Unit]
          Requires=etcd2.service
          [Service]
          ExecStartPre=/usr/bin/etcdctl set /coreos.com/network/config '{ "Network": "10.100.0.0/16" }'
      command: start
    # - name: docker.service
    #   command: restart
    #   content: |
    #     [Unit]
    #     Description=Docker Application Container Engine
    #     Requires=flanneld.service
    #     After=flanneld.service
    #
    #     [Service]
    #     EnvironmentFile=/run/flannel/subnet.env
    #     ExecStartPre=-/usr/bin/ip link set dev docker0 down
    #     ExecStartPre=/usr/sbin/brctl delbr docker0
    #     ExecStart=/usr/bin/docker -d -s=btrfs -H fd:// --bip=${FlANNEL_SUBNET} --mtu=${FLANNEL_MTU}
    #     Restart=on-failure
    #     RestartSec=5
    #
    #     [Install]
    #     WantedBy=multi-user.target


    # - name: docker-tcp.socket
    #   command: start
    #   enable: true
    #   content: |
    #     [Unit]
    #     Description=Docker Socket for the API
    #
    #     [Socket]
    #     ListenStream=2375
    #     Service=docker.service
    #     BindIPv6Only=both
    #
    #     [Install]
    #     WantedBy=sockets.target

    ##
    # Generates keys
    ##
    # - name: generate-serviceaccount-key.service
    #   command: start
    #   content: |
    #     [Unit]
    #     Description=Generate service-account key file
    #     [Service]
    #     ExecStartPre=-/usr/bin/mkdir -p /opt/bin
    #     ExecStart=/bin/openssl genrsa -out /opt/bin/kube-serviceaccount.key 2048 2>/dev/null
    #     RemainAfterExit=yes
    #     Type=oneshot

    ##
    # Sets up
    # /etc/network-environment
    ##
    # - name: setup-network-environment.service
    #   command: start
    #   content: |
    #     [Unit]
    #     Description=Setup Network Environment
    #     Documentation=https://github.com/kelseyhightower/setup-network-environment
    #     Requires=network-online.target
    #     After=network-online.target
    #     [Service]
    #     ExecStartPre=-/usr/bin/mkdir -p /opt/bin
    #     ExecStartPre=/usr/bin/curl -L -o /opt/bin/setup-network-environment -z /opt/bin/setup-network-environment https://github.com/kelseyhightower/setup-network-environment/releases/download/v1.0.0/setup-network-environment
    #     ExecStartPre=/usr/bin/chmod +x /opt/bin/setup-network-environment
    #     ExecStart=/opt/bin/setup-network-environment
    #     RemainAfterExit=yes
    #     Type=oneshot
