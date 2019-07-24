#!/bin/bash

lxc delete kubernetes-master --force                               
lxc delete kubernetes-worker1 --force                               
lxc delete kubernetes-worker2 --force 