#!/bin/bash

#     Setup D1-2: 3 NVMe-oF layers

#     +--------+
#     |  fio   |
#     +--------+
#         |
#         v
# +--------------------+
# |   NVMe disk        |
# | (/dev/nvme0n1)     |
# +--------------------+
#         |
#         v
#     NVMe-TCP
#         |
#         v
# +--------------------+
# |   NVME bdev        |
# +--------------------+
#         |
#         v
#     NVMe-TCP
#         |
#         v
# +--------------------+
# |   NVME bdev        |
# +--------------------+
#         |
#         v
#     NVMe-TCP
#         |
#         v
# +----------------------------+
# |      lvol                  |
# +----------------------------+
# |    lvstore                 |
# +----------------------------+
# |   NVME bdev                |
# +----------------------------+
# |   NVME SSD                 |
# +----------------------------+



/root/spdk/scripts/rpc.py bdev_nvme_attach_controller -b NVMe2 -t PCIe -a 0000:44:00.0
/root/spdk/scripts/rpc.py bdev_lvol_delete_lvstore -l lvstore2
/root/spdk/scripts/rpc.py bdev_lvol_create_lvstore NVMe2n1 lvstore2

/root/spdk/scripts/rpc.py bdev_lvol_create -l lvstore2 -t lvol1 220000

IP="86.109.11.69"

/root/spdk/scripts/rpc.py nvmf_create_transport -t tcp
/root/spdk/scripts/rpc.py nvmf_create_subsystem nqn.2023-01.io.spdk:cnode1 -a -s SPDK00000000000021 -d SPDK_Controller
/root/spdk/scripts/rpc.py nvmf_subsystem_add_ns -g cbf0240d85dc4adbb6ce4af181b34611 nqn.2023-01.io.spdk:cnode1 lvstore2/lvol1
/root/spdk/scripts/rpc.py nvmf_subsystem_add_listener nqn.2023-01.io.spdk:cnode1 -t tcp -a 86.109.11.69 -s 4421
/root/spdk/scripts/rpc.py bdev_nvme_attach_controller -b Nvme1 -t tcp -a 86.109.11.69 -n nqn.2023-01.io.spdk:cnode1 -s 4421 -f ipv4

/root/spdk/scripts/rpc.py nvmf_create_subsystem nqn.2023-01.io.spdk:cnode2 -a -s SPDK00000000000022 -d SPDK_Controller
/root/spdk/scripts/rpc.py nvmf_subsystem_add_ns -g cbf0240d85dc4adbb6ce4af181b34612 nqn.2023-01.io.spdk:cnode2 Nvme1n1
/root/spdk/scripts/rpc.py nvmf_subsystem_add_listener nqn.2023-01.io.spdk:cnode2 -t tcp -a 86.109.11.69 -s 4423
/root/spdk/scripts/rpc.py bdev_nvme_attach_controller -b Nvme2 -t tcp -a 86.109.11.69 -n nqn.2023-01.io.spdk:cnode2 -s 4423 -f ipv4

# Note that there is no RAID bdev here. I just reuse the name raid1 but it is actually the NVME bdev
/root/spdk/scripts/rpc.py nvmf_create_subsystem nqn.2023-01.io.spdk:raid1 -a -s SPDK00000000000020 -d SPDK_Controller
/root/spdk/scripts/rpc.py nvmf_subsystem_add_ns -g cbf0240d85dc4adbb6ce4af181b34616 nqn.2023-01.io.spdk:raid1 Nvme2n1
/root/spdk/scripts/rpc.py nvmf_subsystem_add_listener nqn.2023-01.io.spdk:raid1 -t tcp -a 86.109.11.69 -s 4422
nvme discover -t tcp -a 86.109.11.69 -s 4422
nvme connect -t tcp -a 86.109.11.69 -s 4422 --nqn nqn.2023-01.io.spdk:raid1
