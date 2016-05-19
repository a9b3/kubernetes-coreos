# vim: set ft=yaml:

[Unit]
Description=Hello World Container
Requires=docker.service
After=docker.service

[Service]
ExecStart=/usr/bin/docker run \
  -d \
  -p 8089:8080 \
  --name node-test \
  esayemm/node-test:latest
