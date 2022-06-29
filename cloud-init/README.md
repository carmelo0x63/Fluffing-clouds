# cloud-init

Adapted from: [KVM: Testing cloud-init locally using KVM for a CentOS cloud image](https://fabianlee.org/2020/03/14/kvm-testing-cloud-init-locally-using-kvm-for-a-centos-cloud-image/)

----

### Create a working snapshot from original image, increase size to 10G
We'll be using `qemu-img` (QEMU disk image utility) with `create` command and `-f` (first image format) and `-F` (second image format) flags.
```
$ qemu-img create \
  -f qcow2 \
  -F qcow2 \
  -b /var/lib/libvirt/images/CentOS-7-x86_64-GenericCloud-2111.qcow2 \
  snapshot-centos7-cloudimg.qcow2 10G

Formatting 'snapshot-centos7-cloudimg.qcow2', fmt=qcow2 cluster_size=65536 extended_l2=off compression_type=zlib
size=10737418240 backing_file=/var/lib/libvirt/images/CentOS-7-GenericCloud.latest.x86_64.qcow2 backing_fmt=qcow2
lazy_refcounts=off refcount_bits=16
```

### Verify
Again, `qemu-img`, this time along with `info` command, turns out to be usesful to examine the image we have just created:
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

### Create SSH keypar (**note-to-self**: make sure .gitignore is setup not to commit any keys)
```
$ ssh-keygen -t rsa -b 4096 -f cloud_id_rsa -C ctest1 -N "" -q
```

### Cloud-init and network configuration
Please, refer to `cloud_init.cfg` and `network_config_static.cfg` in this directory. Examples can be found at [Cloud config examples](https://cloudinit.readthedocs.io/en/latest/topics/examples.html).
**IMPORTANT**: use the previously generated public key, `cloud_id_rsa.pub`, to customize `cloud_init.cfg`:
```
...
    ssh-authorized-keys:
      - ssh-rsa *** ctest1
...
```

### Inject metadata into seed image
With `cloud-localds` we'll create a disk for `cloud-init` that's pre-configured with the appropriate metadata:
```
$ cloud-localds -v \
  --network-config=network_config_static.cfg \
  ctest1-seed.qcow2 \
  cloud_init.cfg

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
  --os-type Linux \
  --os-variant centos7.0 \
  --network network:default
...
[   62.731090] cloud-init[1235]: The system is finally up, after 62.72 seconds
```

When the last message is displayed on console the VM is fully deployed. To finally login:</br>
```
$ ssh -o StrictHostKeyChecking=no -o "UserKnownHostsFile=/dev/null" -i cloud_id_rsa centos@<ip_address> 

[centos@ctest1 ~]$ uname -a
Linux ctest1.example.com 3.10.0-1160.45.1.el7.x86_64 #1 SMP Wed Oct 13 17:20:51 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux

[centos@ctest1 ~]$ ip add sho dev eth0 | awk '/inet / { print $2 }'
192.168.122.152/24
```
**NOTE**: `<ip_address>` is declared inside `network_config_static.cfg`.
Additionally, **no password** is set up for user `centos`. Rather, the SSH credentials that have been injected shall be used. The configuration files in this repository use both options, choose wisely.

----

### Same process, tested with Rocky Linux 8.6

1. create image
<pre>
$ qemu-img create \
  -f qcow2 \
  -F qcow2 \
  -b /var/lib/libvirt/images/<b>Rocky-8-GenericCloud.latest.x86_64.qcow2</b> \
  <b>snapshot-rl8-cloudimg.qcow2</b> 10G
</pre>

2. create disk
```
$ cloud-localds -v \
  --network-config=network_config_static.cfg \
  ctest1-seed.qcow2 \
  cloud_init.cfg
```

3. deploy VM
<pre>
$ virt-install --name ctest1 \
  --virt-type kvm \
  --memory 1024 \
  --vcpus 1 \
  --boot hd,menu=on \
  --disk path=ctest1-seed.qcow2,device=cdrom \
  --disk path=<b>snapshot-rl8-cloudimg.qcow2,device=disk</b> \
  --graphics none \
  --os-type Linux \
  --os-variant rhl8.0 \
  --network network:default
</pre>

4. checks
<pre>
[centos@ctest1 ~]$ uname -a
Linux ctest1.example.com 4.18.0-372.9.1.el8.x86_64 #1 SMP Tue May 10 14:48:47 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

[centos@ctest1 ~]$ cat /etc/redhat-release
<b>Rocky Linux release 8.6 (Green Obsidian)</b>
</pre>

**TBD**:
- static IP
- sudo

