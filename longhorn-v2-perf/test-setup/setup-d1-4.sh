#!/bin/bash

#     Setup D1-4: 10 NVMe-oF layers

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

/root/spdk/scripts/rpc.py nvmf_create_subsystem nqn.2023-01.io.spdk:cnode3 -a -s SPDK00000000000023 -d SPDK_Controller
/root/spdk/scripts/rpc.py nvmf_subsystem_add_ns -g cbf0240d85dc4adbb6ce4af181b34613 nqn.2023-01.io.spdk:cnode3 Nvme2n1
/root/spdk/scripts/rpc.py nvmf_subsystem_add_listener nqn.2023-01.io.spdk:cnode3 -t tcp -a 86.109.11.69 -s 4424
/root/spdk/scripts/rpc.py bdev_nvme_attach_controller -b Nvme3 -t tcp -a 86.109.11.69 -n nqn.2023-01.io.spdk:cnode3 -s 4424 -f ipv4

/root/spdk/scripts/rpc.py nvmf_create_subsystem nqn.2023-01.io.spdk:cnode4 -a -s SPDK00000000000024 -d SPDK_Controller
/root/spdk/scripts/rpc.py nvmf_subsystem_add_ns -g cbf0240d85dc4adbb6ce4af181b34614 nqn.2023-01.io.spdk:cnode4 Nvme3n1
/root/spdk/scripts/rpc.py nvmf_subsystem_add_listener nqn.2023-01.io.spdk:cnode4 -t tcp -a 86.109.11.69 -s 4425
/root/spdk/scripts/rpc.py bdev_nvme_attach_controller -b Nvme4 -t tcp -a 86.109.11.69 -n nqn.2023-01.io.spdk:cnode4 -s 4425 -f ipv4

/root/spdk/scripts/rpc.py nvmf_create_subsystem nqn.2023-01.io.spdk:cnode5 -a -s SPDK00000000000025 -d SPDK_Controller
/root/spdk/scripts/rpc.py nvmf_subsystem_add_ns -g cbf0240d85dc4adbb6ce4af181b34615 nqn.2023-01.io.spdk:cnode5 Nvme4n1
/root/spdk/scripts/rpc.py nvmf_subsystem_add_listener nqn.2023-01.io.spdk:cnode5 -t tcp -a 86.109.11.69 -s 4426
/root/spdk/scripts/rpc.py bdev_nvme_attach_controller -b Nvme5 -t tcp -a 86.109.11.69 -n nqn.2023-01.io.spdk:cnode5 -s 4426 -f ipv4

/root/spdk/scripts/rpc.py nvmf_create_subsystem nqn.2023-01.io.spdk:cnode6 -a -s SPDK00000000000026 -d SPDK_Controller
/root/spdk/scripts/rpc.py nvmf_subsystem_add_ns -g cbf0240d85dc4adbb6ce4af181b34616 nqn.2023-01.io.spdk:cnode6 Nvme5n1
/root/spdk/scripts/rpc.py nvmf_subsystem_add_listener nqn.2023-01.io.spdk:cnode6 -t tcp -a 86.109.11.69 -s 4427
/root/spdk/scripts/rpc.py bdev_nvme_attach_controller -b Nvme6 -t tcp -a 86.109.11.69 -n nqn.2023-01.io.spdk:cnode6 -s 4427 -f ipv4

/root/spdk/scripts/rpc.py nvmf_create_subsystem nqn.2023-01.io.spdk:cnode7 -a -s SPDK00000000000027 -d SPDK_Controller
/root/spdk/scripts/rpc.py nvmf_subsystem_add_ns -g cbf0240d85dc4adbb6ce4af181b34617 nqn.2023-01.io.spdk:cnode7 Nvme6n1
/root/spdk/scripts/rpc.py nvmf_subsystem_add_listener nqn.2023-01.io.spdk:cnode7 -t tcp -a 86.109.11.69 -s 4428
/root/spdk/scripts/rpc.py bdev_nvme_attach_controller -b Nvme7 -t tcp -a 86.109.11.69 -n nqn.2023-01.io.spdk:cnode7 -s 4428 -f ipv4

/root/spdk/scripts/rpc.py nvmf_create_subsystem nqn.2023-01.io.spdk:cnode8 -a -s SPDK00000000000028 -d SPDK_Controller
/root/spdk/scripts/rpc.py nvmf_subsystem_add_ns -g cbf0240d85dc4adbb6ce4af181b34618 nqn.2023-01.io.spdk:cnode8 Nvme7n1
/root/spdk/scripts/rpc.py nvmf_subsystem_add_listener nqn.2023-01.io.spdk:cnode8 -t tcp -a 86.109.11.69 -s 4429
/root/spdk/scripts/rpc.py bdev_nvme_attach_controller -b Nvme8 -t tcp -a 86.109.11.69 -n nqn.2023-01.io.spdk:cnode8 -s 4429 -f ipv4

/root/spdk/scripts/rpc.py nvmf_create_subsystem nqn.2023-01.io.spdk:cnode9 -a -s SPDK00000000000029 -d SPDK_Controller
/root/spdk/scripts/rpc.py nvmf_subsystem_add_ns -g cbf0240d85dc4adbb6ce4af181b34619 nqn.2023-01.io.spdk:cnode9 Nvme8n1
/root/spdk/scripts/rpc.py nvmf_subsystem_add_listener nqn.2023-01.io.spdk:cnode9 -t tcp -a 86.109.11.69 -s 4430
/root/spdk/scripts/rpc.py bdev_nvme_attach_controller -b Nvme9 -t tcp -a 86.109.11.69 -n nqn.2023-01.io.spdk:cnode9 -s 4430 -f ipv4

# Note that there is no RAID bdev here. I just reuse the name raid1 but it is actually the NVME bdev
/root/spdk/scripts/rpc.py nvmf_create_subsystem nqn.2023-01.io.spdk:raid1 -a -s SPDK00000000000020 -d SPDK_Controller
/root/spdk/scripts/rpc.py nvmf_subsystem_add_ns -g cbf0240d85dc4adbb6ce4af181b54616 nqn.2023-01.io.spdk:raid1 Nvme9n1
/root/spdk/scripts/rpc.py nvmf_subsystem_add_listener nqn.2023-01.io.spdk:raid1 -t tcp -a 86.109.11.69 -s 4422
nvme discover -t tcp -a 86.109.11.69 -s 4422
nvme connect -t tcp -a 86.109.11.69 -s 4422 --nqn nqn.2023-01.io.spdk:raid1


