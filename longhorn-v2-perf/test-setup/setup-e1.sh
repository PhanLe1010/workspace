#!/bin/bash

/root/spdk/scripts/rpc.py bdev_nvme_attach_controller -b NVMe2 -t PCIe -a 0000:44:00.0
/root/spdk/scripts/rpc.py bdev_lvol_delete_lvstore -l lvstore2
/root/spdk/scripts/rpc.py bdev_lvol_create_lvstore NVMe2n1 lvstore2
/root/spdk/scripts/rpc.py bdev_lvol_create -l lvstore2 -t lvol1 220000
# Noted down the bdev UUID

/root/spdk/scripts/rpc.py nvmf_create_transport -t tcp
/root/spdk/scripts/rpc.py nvmf_create_subsystem nqn.2023-01.io.spdk:raid1 -a -s SPDK00000000000020 -d SPDK_Controller
/root/spdk/scripts/rpc.py nvmf_subsystem_add_ns -g cbf0240d85dc4adbb6ce4af181b34616 nqn.2023-01.io.spdk:raid1 <REPLEACED_WITH_BDEV_UUID>
/root/spdk/scripts/rpc.py nvmf_subsystem_add_listener nqn.2023-01.io.spdk:raid1 -t tcp -a 86.109.11.69 -s 4422

nvme discover -t tcp -a 86.109.11.69 -s 4422
nvme connect -t tcp -a 86.109.11.69 -s 4422 --nqn nqn.2023-01.io.spdk:raid1
