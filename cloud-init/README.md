# cloud-init

source: [KVM: Testing cloud-init locally using KVM for a CentOS cloud image](https://fabianlee.org/2020/03/14/kvm-testing-cloud-init-locally-using-kvm-for-a-centos-cloud-image/)

----

### Create a working snapshot from original image, increase size to 10G
```
$ qemu-img create \
  -b /var/lib/libvirt/images/CentOS-7-GenericCloud.latest.x86_64.qcow2 \
  -F qcow2 \
  -f qcow2 \
  snapshot-centos7-cloudimg.qcow2 10G

Formatting 'snapshot-centos7-cloudimg.qcow2', fmt=qcow2 cluster_size=65536 extended_l2=off compression_type=zlib size=10737418240 backing_file=/var/lib/libvirt/images/CentOS-7-GenericCloud.latest.x86_64.qcow2 backing_fmt=qcow2 lazy_refcounts=off refcount_bits=16
```

### Verify
```
$ qemu-img info snapshot-centos7-cloudimg.qcow2
image: snapshot-centos7-cloudimg.qcow2
file format: qcow2
virtual size: 10 GiB (10737418240 bytes)
disk size: 196 KiB
cluster_size: 65536
backing file: /var/lib/libvirt/images/CentOS-7-GenericCloud.latest.x86_64.qcow2
backing file format: qcow2
Format specific information:
    compat: 1.1
    compression type: zlib
    lazy refcounts: false
    refcount bits: 16
    corrupt: false
    extended l2: false
```

### Create SSH keypar (note-to-self: make sure .gitignore is setup not to commit any keys)
```
$ ssh-keygen -t rsa -b 4096 -f id_rsa -C ctest1 -N "" -q
```

### Cloud-init and network configuration
Please, refer to `cloud_init.cfg` and `network_config_static.cfg` in this directory

### Inject metadata into seed image
```
$ cloud-localds -v --network-config=network_config_static.cfg ctest1-seed.qcow2 cloud_init.cfg
wrote ctest1-seed.qcow2 with filesystem=iso9660 and diskformat=raw
```

### Verify
```
$ qemu-img info ctest1-seed.qcow2
image: ctest1-seed.qcow2
file format: raw
virtual size: 368 KiB (376832 bytes)
disk size: 368 KiB
```

### Start VM
```
$ virt-install --name ctest1 \
  --virt-type kvm \
  --memory 1024 \
  --vcpus 1 \
  --boot hd,menu=on \
  --disk path=ctest1-seed.qcow2,device=cdrom \
  --disk path=snapshot-centos7-cloudimg.qcow2,device=disk \
  --graphics none \
  --os-type Linux --os-variant rhl8.0 \
  --network network:default
...
[   62.731090] cloud-init[1235]: The system is finally up, after 62.72 seconds
```

When the last message is displayed on console the VM is fully deployed.

