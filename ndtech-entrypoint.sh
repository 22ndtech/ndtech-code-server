#!/bin/sh
sudo chown coder /home/coder/.kube/*

/usr/bin/entrypoint.sh --bind-addr 0.0.0.0:8080 .