#!/bin/bash
docker run  --name fedora -d pycontribs/fedora:latest sleep 60000000
docker run  --name centos7 -d pycontribs/centos:7 sleep 60000000
docker run  --name ubuntu -d pycontribs/ubuntu:latest sleep 60000000
ansible-playbook  -i ./inventory/prod.yml  ./site.yml
docker stop ubuntu > /dev/null && docker rm ubuntu > /dev/null
docker stop fedora > /dev/null && docker rm fedora > /dev/null
docker stop centos7 > /dev/null && docker rm centos7 > /dev/null
