#!/bin/bash

kubernetesMachines=("kubernetes-master" "kubernetes-worker1" "kubernetes-worker2")

for i in "${kubernetesMachines[@]}"
do
    lxc launch images:centos/7 $i --profile kubernetes
    sleep 10
    cat prepare.sh | lxc exec $i bash
    # cat bootstrap-kube.sh | lxc exec $i bash
done


